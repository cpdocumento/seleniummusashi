current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"
require "sqlite3"

class CreateAccess < MiniTest::Test

  include Common::AuthenticationHelper
  include Common::UsersHelper
  include Common::KeypairHelper
  include Common::SecurityGroupHelper
  include Common::FloatingIPHelper

  def setup
    @test_data = Data.config.test_data
    @config = Data.config.setup
    @db = ::SQLite3::Database.new "testdb.db"
    @driver = Selenium::WebDriver.for @config["test_browser"].to_sym
    @driver.get(@config["envi"] + "/")
  end

  def teardown
    @driver.quit
  end
  
  def test_import_keypair
    @driver.manage().window().maximize()
    wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    result = @db.execute("select pm from userindex").first
    current_pm_index = result[0]
  
    login(@driver, @test_data["user_mem"] + current_pm_index.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + 0.to_s }
    for i in 1..10
      import_keypair(@driver, @test_data["res_keypair"] + i.to_s, @test_data["keypair_keys"])
    end
  end
  
  def test_create_secgroup
    @driver.manage().window().maximize()
    wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    result = @db.execute("select pm from userindex").first
    current_pm_index = result[0]
  
    login(@driver, @test_data["user_mem"] + current_pm_index.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + 0.to_s }
    for i in 1..10
      create_secgroup(@driver, @test_data["res_secgroup"] + i.to_s, @test_data["common_description"])
    end
  end

  def test_add_rule
    @driver.manage().window().maximize()
    wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    result = @db.execute("select pm from userindex").first
    current_pm_index = result[0]
  
    login(@driver, @test_data["user_mem"] + current_pm_index.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + 0.to_s }    
    
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
    for i in 1..10
      custom_rule(@driver, @test_data["res_secgroup"] + 1.to_s, sec_rules)
    end
  end

  def test_allocate_floating_ip
    @driver.manage().window().maximize()
    wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    result = @db.execute("select pm from userindex").first
    current_pm_index = result[0]
  
    login(@driver, @test_data["user_mem"] + current_pm_index.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + 0.to_s }
    for i in 1..3
      allocateIP(@driver)
    end
  end
	
end
