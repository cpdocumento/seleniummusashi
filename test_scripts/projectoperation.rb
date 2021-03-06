current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"

class ScenarioC < MiniTest::Test

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
    result = @db.execute("select pmc from userindex").first
    current_pm_index = result[0]
    warning = 30
    error = 35
    increase = 5
    
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
    
    # CREATE KP, SG, FIP
    login(@driver, @test_data["user_mem"] + current_pm_index.to_s + "c", @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + 0.to_s + "c" }
    for i in loop_start..loop_end
      import_keypair(@driver, @test_data["res_keypair"] + i.to_s, @test_data["res_key"])
    end
    puts "Created #{ loop_end } keypairs."
    for i in loop_start..loop_end
      create_secgroup(@driver, @test_data["res_secgroup"] + i.to_s, @test_data["common_description"])
    end
    puts "Created #{ loop_end } security groups."
    for i in loop_start..loop_end
      custom_rule(@driver, @test_data["res_secgroup"] + i.to_s, sec_rules)
    end
    puts "Added 10 security group rules for #{ loop_end } security groups."
    for i in loop_start..loop_end
      allocateIP(@driver)
    end
    puts "Allocated #{ loop_end } IPs."
    
    # CREATE VMS
    puts "\n======Creating VMs now======."
    for i in loop_start..loop_end
      createInstance(@driver, @test_data["res_instance"] + i.to_s, @test_data["res_flavor"], @test_data["res_image"], "default", @test_data["res_keypair"] + i.to_s)
    end
    puts "Finished creating #{ loop_end } instances."
    for i in loop_start..loop_end
      createVolume(@driver, @test_data["res_volume"] + i.to_s, @test_data["common_description"], @test_data["res_volume_size"].to_i)
    end
    puts "Finished creating #{ loop_end } volumes."
    for i in loop_start..loop_end
      attachVolume(@driver, @test_data["res_volume"] + i.to_s, @test_data["res_instance"] + i.to_s)
    end
    puts "Finished attaching a volume for each of the  #{ loop_end } instances."
    wait.until { @driver.find_element(:css, "i.fa.fa-lock").displayed? }
    @driver.find_element(:css, "i.fa.fa-lock").click
    for i in loop_start..loop_end
      wait.until { @driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr[2]/td[2]").displayed? }    
      ip = @driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr[#{ i+1 }]/td[2]").text
      attachIP(@driver, @test_data["res_instance"] + i.to_s, ip)
    end
    puts "Finished attaching an IP for each of the  #{ loop_end } instances."
    
    # CREATE AND DELETE SNAPSHOTS
    for i in loop_start..loop_end
      createSnapshot(@driver, @test_data["res_instance"] + i.to_s,  @test_data["res_snapshot"] + i.to_s)
    sleep 2
    end
    puts "Finished creating a snapshot for each of the  #{ loop_end } instances."
    logout(@driver)
    puts "\n======Logged out Project Member. Logging in Project Admin now.====="
    sleep 2
    login(@driver, @test_data["user_pa"] + 0.to_s + "c", @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/a").text == @test_data["user_project"] + 0.to_s + "c" } 
    for i in loop_start..loop_end
      deleteSnapshot(@driver,  @test_data["res_snapshot"] + i.to_s)
      sleep 2
      deleteBootableVolume(@driver,  "snapshot for " + @test_data["res_snapshot"] + i.to_s)
    end
    puts "Finished deleting the #{ loop_end }  instance snapshots and their equivalent volume snapshots." 
    logout(@driver)
    puts "\n======Logged out Project Admin. Logging in Project Member now.====="
    # PM MONITORING
    login(@driver, @test_data["user_mem"] + current_pm_index.to_s + "c", @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + 0.to_s + "c" }
    for i in loop_start..loop_end
      warning = 30
      error = 35
      increase = 5
      for t in loop_start..loop_end
        update_instance_monitoring(@driver, @test_data["res_instance"] + i.to_s, warning, error)
        warning += increase
        error += increase
      end      
    end
    puts "Finished updating monitoring settings #{ loop_end } times for each of the #{ loop_end } instances."
     
    # DELETE VM
    puts "\n======Deleting VMs now======."
    for i in loop_start..loop_end
      detachVolume(@driver, @test_data["res_volume"] + i.to_s)
    end
    puts "Detached each volume attached to and instance #{loop_end} times."
    for i in loop_start..loop_end
      detachIP(@driver, @test_data["res_instance"] + i.to_s)
    end
    puts "Detached each IP attached to an instance #{loop_end} times."
    for i in loop_start..loop_end
       stopInstance(@driver, @test_data["res_instance"] + i.to_s)
    end
    puts "All #{ loop_end } instances have been stopped."
    # do volume snapshots cleanup
    deleteAllVolumeSnapshots(@driver)
    puts "Cleaned up all volume snapshots first."
    for i in loop_start..loop_end
      deleteVolume(@driver, @test_data["res_volume"] + i.to_s)
    end
    puts "All #{ loop_end } volumes have been deleted."
    for i in loop_start..loop_end
      deleteInstance(@driver, @test_data["res_instance"] + i.to_s)
    end
    puts "All #{ loop_end } instances have been deleted."
    
    # DELETE KP, SG, RELEASE FIP
    for i in loop_start..loop_end
      delete_keypair(@driver, @test_data["res_keypair"] + i.to_s)
    end
    puts "All #{ loop_end } keypairs have been deleted."
    for i in loop_start..loop_end
      delete_secgroup(@driver, @test_data["res_secgroup"] + i.to_s)
    end
    puts "All #{ loop_end } security groups have been deleted."
    
    wait.until { @driver.find_element(:css, "i.fa.fa-lock").displayed? }
    @driver.find_element(:css, "i.fa.fa-lock").click
    for i in loop_start..loop_end
      wait.until { @driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr[2]/td[2]").displayed? }    
      ip = @driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr[2]/td[2]").text
      disallocateIP(@driver, ip)
    end
    puts "All #{ loop_end } floating IPs have been release/disallocated."    
    logout(@driver)    
    puts "\n======Logged out Project Member. Logging in Project Admin now.====="
    # DELETE PMS
    login(@driver, @test_data["user_pa"] + "0c", @test_data["user_password"])
    result = @db.execute("select pmc from userindex").first.map(&:to_i)
    current_pm_index = result[0]
    last_pm_index = current_pm_index + (loop_end - 1)
    for i in current_pm_index..last_pm_index
      delete_member(@driver, @test_data["user_mem"] + i.to_s + "c")
    end
    @db.execute "update userindex set pmc=?", last_pm_index + 1
    puts "Deleted #{ loop_end } members."
    logout(@driver)
  end

end