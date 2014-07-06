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
    vcpu = 100
    instances = 20
    ram = 10000
    fip = 20
    keypair = 5
    secgroup = 5
    secgroup_rules = 5
    storage = 10000
    volumes = 20
    snapshots =20
    range = 10
    increment = 5

    login(@driver, admin0, @test_data["def_admin_pass"])
      range.times do
         vcpu+=increment
         instances+=increment
         ram+=increment
         fip+=increment
         keypair+=increment
         secgroup+=increment
         secgroup_rules+=increment
         storage+=increment
         volumes+=increment
         snapshots+=increment
         range+=increment

         updatequota(@driver, proj0, vcpu, instances, ram, fip, keypair, secgroup, secgroup_rules, storage, volumes, snapshots)
      end
    logout(@driver)
    
    
  end
end