current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"
require "sqlite3"

class DeleteAccess < MiniTest::Test

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
  
  def test_delete_keypair
    login(@driver, @test_data["user_mem"], @test_data["user_password"])
    @driver.find_element(:css, "i.fa.fa-lock").click
    !60.times{ break if (@driver.find_element(:xpath, "//div[@id='dash-access']/table[3]/tbody/tr[2]/td").displayed? rescue false); sleep 1 }
    for i in 1..10
      row =2
      !60.times{ break if (@driver.find_element(:xpath, "//div[@id='dash-access']/table[3]/tbody/tr[#{row}]/td").displayed? rescue false); sleep 1 }
      keypair_name = @driver.find_element(:xpath, "//div[@id='dash-access']/table[3]/tbody/tr[#{row}]/td").text
      delete_keypair(@driver, keypair_name, row)
      row +=1
    end
  end
	 
end