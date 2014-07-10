current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"

class DeletePM < MiniTest::Test

  include Common::AuthenticationHelper
  include Common::UsersHelper

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
  
  def test_deletePM    
    login(@driver, @test_data["user_pa"] + 0.to_s, @test_data["user_password"])
    result = @db.execute("select pm from userindex").first.map(&:to_i)
    current_pm_index = result[0]
    last_pm_index = current_pm_index + 9
    
    for i in current_pm_index..last_pm_index
      delete_member(@driver, @test_data["user_mem"] + i.to_s)
    end
    
    @db.execute "update userindex set pm=?", last_pm_index + 1
    
    logout(@driver)
  end
end