current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"

class ScenarioD < MiniTest::Test

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
  
  def test_wholeOperation
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
    sec_rules = [ {from:"-1", to:"-1", ip:"0.0.0.0/0", protocol:"ICMP"},
                  {from:"443", to:"443", ip:"0.0.0.0/0", protocol:"TCP"},
                  {from:"161", to:"161", ip:"0.0.0.0/0", protocol:"UDP"},
                  {from:"22", to:"22", ip:"0.0.0.0/0", protocol:"TCP"},
                  {from:"80", to:"80", ip:"0.0.0.0/0", protocol:"TCP"},
                  {from:"8080", to:"8080", ip:"0.0.0.0/0", protocol:"TCP"},
                  {from:"3306", to:"3306", ip:"0.0.0.0/0", protocol:"TCP"},
                  {from:"1", to:"4", ip:"0.0.0.0/0", protocol:"TCP"},
                  {from:"2", to:"5", ip:"0.0.0.0/0", protocol:"UDP"},
                  {from:"3", to:"6", ip:"0.0.0.0/0", protocol:"ICMP"}
                ]
    login(@driver, @test_data["user_mem"] + "1d", @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + "0d"}

    createVolume(@driver, @test_data["res_volume"], @test_data["common_description"], @test_data["res_volume_size"].to_i)
    puts "Finished creating volume."
    
    attachVolume(@driver, @test_data["res_volume"], @test_data["res_instance"])
    puts "Finished attaching the volume."
    wait.until { @driver.find_element(:css, "i.fa.fa-lock").displayed? }
    @driver.find_element(:css, "i.fa.fa-lock").click
    wait.until { @driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr[2]/td[2]").displayed? }    
    ip = @driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr[2]/td[2]").text
    attachIP(@driver, @test_data["res_instance"], ip)
    puts "Finished attaching an IP to instance."
    
    warning = 30
    error = 35
    increase = 5
    for i in loop_start..loop_end
      update_instance_monitoring(@driver, @test_data["res_instance"], warning, error)
      warning += increase
      error += increase          
    end
    puts "Finished updating monitoring settings #{ loop_end } times for the instance."
     
    # detach resources from VM
    puts "\n======Detaching resources from instance now======."
    detachVolume(@driver, @test_data["res_volume"])
    puts "Detached volume."
    detachIP(@driver, @test_data["res_instance"])
    puts "Detached IP."
    stopInstance(@driver, @test_data["res_instance"])
    puts "Instance has been stopped."
    deleteVolume(@driver, @test_data["res_volume"])
    puts "Volume has been deleted."
    startInstance(@driver, @test_data["res_instance"])
    puts "Instance has been started."
    
    logout(@driver)
  end

end