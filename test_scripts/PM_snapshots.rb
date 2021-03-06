current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"

class CreateSnapshot < Minitest::Test

  include Common::InstanceHelper
  include Common::AuthenticationHelper
  include Common::VolumeHelper

  def setup
    @test_data = Data.config.test_data
    @config = Data.config.setup
    @db = SQLite3::Database.new "testdb.db"
    @driver = Selenium::WebDriver.for @config["test_browser"].to_sym
    @driver.get(@config["envi"] + "/")
  end

  def teardown
    @driver.quit
  end
  
  def test_createSnapshot
    @driver.manage().window().maximize()
    wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    result = @db.execute("select pm from userindex").first
    current_pm_index = result[0]

    login(@driver, @test_data["user_mem"] + current_pm_index.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/span").text == @test_data["user_project"] + 0.to_s }
    
    for i in 1..10
      createSnapshot(@driver, @test_data["res_instance"] + i.to_s,  @test_data["res_snapshot"] + i.to_s)
    end
  
    logout(@driver)  
  end
  
end