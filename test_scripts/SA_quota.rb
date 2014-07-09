current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"

class ManageQuota < MiniTest::Test

  include Common::QuotaHelper
  include Common::AuthenticationHelper

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
  
  def test_update_quota
    vcpu = 50
    instances = 15
    ram = 10000
    fip = 15
    keypair = 5
    secgroup = 5
    secgroup_rules = 5
    storage = 10000
    volumes = 15
    snapshots = 15
    range = 10
    increment = 10

    login(@driver, @test_data["user_admin"] + 0.to_s, @test_data["user_password"])
      range.times do
         vcpu += increment
         instances += increment
         ram += increment
         fip += increment
         keypair += increment
         secgroup += increment
         secgroup_rules += increment
         storage += increment
         volumes += increment
         snapshots += increment
         range += increment

         updatequota(@driver, @test_data["user_project"] + 0.to_s, vcpu, instances, ram, fip, keypair, secgroup, secgroup_rules, storage, volumes, snapshots)
      end
    logout(@driver)

  end

end