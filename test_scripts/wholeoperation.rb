current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"

class ScenarioA < MiniTest::Test

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
    loop_start = 1
    loop_end = 10
  end

  def teardown
    @driver.quit
  end
  
  def test_wholeOperation
    @driver.manage().window().maximize()
    
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
    login(@driver, @test_data["user_admin"] + 0.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"dash-mainbar\"]/div/div[2]/ul[2]/li[1]/span").text =~ /SYSTEM ADMIN/}      
    for i in loop_start..loop_end 
      warning += increase
      error += increase
      update_settings(@driver, warning, error)
    end
    # change the quota for project where testing is to take place
    updatequota(@driver, @test_data["user_project"] + 0.to_s, q_vcpu, q_instances, q_ram, q_fip, q_keypair, q_secgroup, q_secgroup_rules, q_storage, q_volumes, q_snapshots)
    logout(@driver)
    
    # CREATE KP, SG, FIP
    login(@driver, @test_data["user_mem"] + current_pm_index.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + 0.to_s }
    for i in loop_start..loop_end
      import_keypair(@driver, @test_data["res_keypair"] + i.to_s, @test_data["keypair_keys"])
    end
    for i in loop_start..loop_end
      create_secgroup(@driver, @test_data["res_secgroup"] + i.to_s, @test_data["common_description"])
    end
    ############################
    # set rules here
    # allocate IP here
    #for i in loop_start..loop_end
    #  allocateIP(@driver)
    #end
    ###########################
    
    # CREATE VMS
    for i in loop_start..loop_end
      createInstance(@driver, @test_data["res_instance"] + i.to_s, @test_data["res_flavor"], @test_data["res_image"], "default", @test_data["res_keypair"] + i.to_s)
    end
    for i in loop_start..loop_end
      createVolume(@driver, @test_data["res_volume"] + i.to_s, @test_data["common_description"], @test_data["res_volume_size"].to_i)
    end
    for i in loop_start..loop_end
      attachVolume(@driver, @test_data["res_volume"] + i.to_s, @test_data["res_instance"] + i.to_s)
    end
    wait.until { @driver.find_element(:css, "i.fa.fa-lock").displayed? }
    @driver.find_element(:css, "i.fa.fa-lock").click
    for i in loop_start..loop_end
      wait.until { @driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr[2]/td[2]").displayed? }    
      ip = @driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr[#{ i+1 }]/td[2]").text
      attachIP(@driver, @test_data["res_instance"] + i.to_s, ip)
    end
    
    # CREATE AND DELETE SNAPSHOTS
    for i in loop_start..loop_end
      createSnapshot(@driver, @test_data["res_instance"] + i.to_s,  @test_data["res_snapshot"] + i.to_s)
    end
    logout(@driver)
    login(@driver, @test_data["user_pa"] + 0.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/a").text == @test_data["user_project"] + 0.to_s } 
    for i in loop_start..loop_end
      deleteSnapshot(@driver,  @test_data["res_snapshot"] + i.to_s)
      deleteBootableVolume(@driver,  "snapshot for " + @test_data["res_snapshot"] + i.to_s)
    end
    logout(@driver)
    
    # PM MONITORING
    login(@driver, @test_data["user_mem"] + current_pm_index.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + 0.to_s }
    ############################
    #insert pm monitoring here
    ############################
     
    # DELETE VM
    for i in loop_start..loop_end
      detachVolume(@driver, @test_data["res_volume"] + i.to_s)
    end
    for i in loop_start..loop_end
      detachIP(@driver, @test_data["res_instance"] + i.to_s)
    end
    for i in loop_start..loop_end
       stopInstance(@driver, @test_data["res_instance"] + i.to_s)
    end
    for i in loop_start..loop_end
      deleteVolume(@driver, @test_data["res_volume"] + i.to_s)
    end    
    for i in loop_start..loop_end
      deleteInstance(@driver, @test_data["res_instance"] + i.to_s)
    end 
    
    # DELETE KP, SG, RELEASE FIP
    for i in loop_start..loop_end
      delete_keypair(@driver, @test_data["res_keypair"] + i.to_s)
    end
    for i in loop_start..loop_end
      delete_secgroup(@driver, @test_data["res_secgroup"] + i.to_s)
    end
    logout(@driver)
    
    # DELETE PMS
    login(@driver, @test_data["user_pa"] + 0.to_s, @test_data["user_password"])
    result = @db.execute("select pm from userindex").first.map(&:to_i)
    current_pm_index = result[0]
    last_pm_index = current_pm_index + (loop_end - 1)
    for i in current_pm_index..last_pm_index
      delete_member(@driver, @test_data["user_mem"] + i.to_s)
    end
    @db.execute "update userindex set pm=?", last_pm_index + 1
    logout(@driver)
    
    # CHANGE PROJECT QUOTA
    login(@driver, @test_data["user_admin"] + 0.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"dash-mainbar\"]/div/div[2]/ul[2]/li[1]/span").text =~ /SYSTEM ADMIN/}
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
      q_range += 5
      updatequota(@driver, @test_data["user_project"] + 0.to_s, q_vcpu, q_instances, q_ram, q_fip, q_keypair, q_secgroup, q_secgroup_rules, q_storage, q_volumes, q_snapshots)
    end
    
    # DELETE PROJECTS/PAS
    pa_result = @db.execute("select pa from userindex").first.map(&:to_i)
    current_pa_index = pa_result[0]
    last_pa_index = current_pa_index + loop_end
    for i in current_pa_index..last_pa_index
      delete_pa(@driver, @test_data["user_pa"] + i.to_s)
    end
    @db.execute "update userindex set pa=?", last_pa_index + 1    
    logout(@driver)
  end

end