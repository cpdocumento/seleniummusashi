current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"

class DeleteProject < MiniTest::Test

  include Common::UsersHelper
  include Common::AuthenticationHelper

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
  
  def test_deletePA    
    login(@driver, @test_data["user_admin"] + 0.to_s, @test_data["user_password"])
    result = @db.execute("select pa from userindex").first.map(&:to_i)
    current_pa_index = result[0]
    last_pa_index = current_pa_index + 9
    
    for i in current_pa_index..last_pa_index
      delete_pa(@driver, @test_data["user_pa"] + i.to_s)
    end
    
    @db.execute "update userindex set pa=?", last_pa_index + 1
    
    logout(@driver)
  end
end