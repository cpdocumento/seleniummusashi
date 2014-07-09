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
    login(@driver, @test_data["user_mem"], @test_data["user_password"])
    @driver.find_element(:css, "i.fa.fa-lock").click
    for i in 1..10
      import_keypair(@driver, @test_data["keypair_name"] + i.to_s, @test_data["keypair_keys"])
    end
  end

end