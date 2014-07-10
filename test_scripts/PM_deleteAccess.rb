current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"
require "sqlite3"

class DeleteAccess < MiniTest::Test

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
  
  def test_delete_keypair
    @driver.manage().window().maximize()
    wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    result = @db.execute("select pm from userindex").first
    current_pm_index = result[0]
		
    login(@driver, @test_data["user_mem"] + current_pm_index.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + 0.to_s }
    for i in 1..10
      delete_keypair(@driver, @test_data["res_keypair"] + i.to_s)
    end
  end

  def test_delete_secgroup
    @driver.manage().window().maximize()
    wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    result = @db.execute("select pm from userindex").first
    current_pm_index = result[0]
		
    login(@driver, @test_data["user_mem"] + current_pm_index.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + 0.to_s }
    for i in 1..10
      delete_secgroup(@driver, @test_data["res_secgroup"] + i.to_s)
    end
  end
end
