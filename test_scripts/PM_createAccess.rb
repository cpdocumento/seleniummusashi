current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"
require "sqlite3"

class CreateAccess < MiniTest::Test

  include Common::AuthenticationHelper
  include Common::UsersHelper
  include Common::KeypairHelper
  include Common::SecurityGroupHelper

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

  #def test_add_rule
  #  login(@driver, @test_data["user_mem"] + 1.to_s, @test_data["user_password"])
  #  
  #  custom_rule(@driver, @test_data["res_secgroup"])
  #end

  def test_allocate_floating_ip
    @driver.manage().window().maximize()
    wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    result = @db.execute("select pm from userindex").first
    current_pm_index = result[0]
		
    login(@driver, @test_data["user_mem"] + current_pm_index.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + 0.to_s }
    for i in 1..8
      allocateIP(@driver)
    end
  end
	
end
