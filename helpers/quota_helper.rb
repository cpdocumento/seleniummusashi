module Common
  module QuotaHelper
 
 def updatequota(driver, project_name, vcpu, instances, ram, fip, keypair, secgroup, secgroup_rules, storage, volumes, snapshots, expect_entry=true)
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)

      # Find manage quota for specific project
      !60.times{ break if (driver.find_element(:xpath, "//tr[@class='ng-scope']/td[normalize-space(text())=\'#{ project_name }\'").displayed? rescue false); sleep 1 }
      driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ project_name }\"]/..//button[2]").click
      driver.find_element(:xpath, "(//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ project_name }\"]/..//a[contains(text(),'Manage Quota')])").click
     
      # Verify if already in manage quota
      !60.times{ break if (driver.find_element(:link_text, "Compute").displayed? rescue false); sleep 1 }
     
      # Update quota limit
       driver.find_element(:name, "vcpus").clear
       driver.find_element(:name, "vcpus").send_keys(vcpu)
       driver.find_element(:name, "instances").clear
       driver.find_element(:name, "instances").send_keys(instances)
       driver.find_element(:name, "ram").clear
       driver.find_element(:name, "ram").send_keys(ram)
       driver.find_element(:name, "floating_ips").clear
       driver.find_element(:name, "floating_ips").send_keys(fip)
       driver.find_element(:name, "keypairs").clear
       driver.find_element(:name, "keypairs").send_keys(keypair)
       driver.find_element(:name, "sec_groups").clear
       driver.find_element(:name, "sec_groups").send_keys(secgroup)
       driver.find_element(:name, "sec_group_rules").clear
       driver.find_element(:name, "sec_group_rules").send_keys(secgroup_rules)
       driver.find_element(:name, "storage").clear
       driver.find_element(:name, "storage").send_keys(storage)
       driver.find_element(:name, "volumes").clear
       driver.find_element(:name, "volumes").send_keys(volumes)
       driver.find_element(:name, "snapshots").clear
       driver.find_element(:name, "snapshots").send_keys(snapshots)
       driver.find_element(:xpath, "//div[3]/button[2]").click

      # Check if user is redirected back to projects page and quota has been updated
       !30.times{ break if (driver.find_element(:link_text, "Quotas for #{project_name} has been successfully updated.").displayed? rescue false); sleep 1 }
    end

  end
end