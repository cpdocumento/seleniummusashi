current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"

class DeleteSnapshot < Minitest::Test

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

    login(@driver, @test_data["user_pa"] + 0.to_s, @test_data["user_password"])
    wait.until { @driver.find_element(:xpath, "//*[@id=\"head-project-name\"]/span/a").text == @test_data["user_project"] + 0.to_s }
    
    for i in 1..10
      deleteSnapshot(@driver,  @test_data["res_snapshot"] + i.to_s)
      deleteBootableVolume(@driver,  "snapshot for " + @test_data["res_snapshot"] + i.to_s)
    end
    
    logout(@driver)
    
  end
end