current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"

class ScenarioB < MiniTest::Test

  include Common::AuthenticationHelper
  include Common::UsersHelper
  include Common::MonitoringHelper
  include Common::InstanceHelper
  include Common::FloatingIPHelper
  include Common::KeypairHelper
  include Common::VolumeHelper
  include Common::QuotaHelper
  include Common::SecurityGroupHelper 
  
  def setup
    @test_data = Data.config.test_data
    @config = Data.config.setup
    @db = SQLite3::Database.new "testdb.db"
    @driver = Selenium::WebDriver.for @config["test_browser"].to_sym
    @driver.get(@config["envi"] + "/")
    
    @admin_account = @test_data["def_admin_user"]
    @admin_pass = @test_data["def_admin_pass"]
  end

  def teardown
    @driver.quit
  end
  
  def test_iaasOperation
    @driver.manage().window().maximize()
    
    # number of times to execute
    loop_start = 1
    loop_end = 10
    
    # variables used
    wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    result = @db.execute("select pm from userindex").first
    current_pm_index = result[0]
    warning = 30
    error = 35
    increase = 5
    q_vcpu = 50
    q_instances = 15
    q_ram = 50000
    q_fip = 15
    q_keypair = 15
    q_secgroup = 15
    q_secgroup_rules = 20
    q_storage = 10000
    q_volumes = 20
    q_snapshots = 30
    
    # MONITORING SETTINGS
    puts "\n======Logging in SA account======"
    login(@driver, @admin_account, @admin_pass)
    wait.until { @driver.find_element(:xpath, "//*[@id=\"dash-mainbar\"]/div/div[2]/ul[2]/li[1]/span").text =~ /SYSTEM ADMIN/}      
    for i in loop_start..loop_end 
      warning += increase
      error += increase
      update_settings(@driver, warning, error)
    end
    puts "Monitoring settings have been updated #{ loop_end } times."
    for i in loop_start..loop_end
      q_vcpu += 5
      q_instances += 5
      q_ram += 5
      q_fip += 5
      q_keypair += 5
      q_secgroup += 5
      q_secgroup_rules += 5
      q_storage += 5
      q_volumes += 5
      q_snapshots += 5
      updatequota(@driver, @test_data["user_project"] + 0.to_s, q_vcpu, q_instances, q_ram, q_fip, q_keypair, q_secgroup, q_secgroup_rules, q_storage, q_volumes, q_snapshots)
    end
    puts "Updated the quota for the user project #{ loop_end } times"
    
    # DELETE PROJECTS/PAS
    pa_result = @db.execute("select pa from userindex").first.map(&:to_i)
    current_pa_index = pa_result[0]
    last_pa_index = current_pa_index + loop_end
    for i in current_pa_index..last_pa_index
      delete_pa(@driver, @test_data["user_pa"] + i.to_s)
    end
    @db.execute "update userindex set pa=?", last_pa_index + 1
    puts "Deleted #{ loop_end } project admins and their projects."
    logout(@driver)
  end

end