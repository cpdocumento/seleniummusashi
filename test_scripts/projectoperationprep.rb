current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"

class ScenarioCPrep < MiniTest::Test

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
  
  def test_prepareProjectOperation
    @driver.manage().window().maximize()
    
    # number of times to execute
    loop_start = 1
    loop_end = 10
    
    # variables used
    wait = Selenium::WebDriver::Wait.new(:timeout => 20)

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
    # change the quota for project where testing is to take place
    updatequota(@driver, @test_data["user_project"] + 0.to_s + "c", q_vcpu, q_instances, q_ram, q_fip, q_keypair, q_secgroup, q_secgroup_rules, q_storage, q_volumes, q_snapshots)
    puts "Updated project quota where testing is to take place."
    logout(@driver)
  end

end