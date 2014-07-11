module Common
  module QuotaHelper
  
  def updatequota(driver, project_name, vcpu, instances, ram, fip, keypair, secgroup, secgroup_rules, storage, volumes, snapshots, expect_entry=true)
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)

    wait.until { driver.find_element(:css, "i.fa.fa-th").displayed? }
    driver.find_element(:css, "i.fa.fa-th").click
    sleep 2
    # Find manage quota for specific project
    wait.until { driver.find_element(:xpath, "//div[2]/table/tbody/tr/td[normalize-space(text())=\"#{ project_name }\"]").displayed? }
    driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ project_name }\"]/..//button[2]").click
    driver.find_element(:xpath, "(//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ project_name }\"]/..//a[contains(text(),'Manage Quota')])").click
     
    # Verify if already in manage quota
    wait.until { driver.find_element(:xpath, "//div[2]/form/h3[1]").text =~ /Compute/ } 
    
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
    driver.find_element(:xpath, "/html/body/div[3]/div/div/div[3]/button[2]").click

    # Check if user is redirected back to projects page and quota has been updated
    wait.until { !(driver.find_element(:xpath, "/html/body/div[3]/div/div").displayed?) }
    assert !60.times{ break if (driver.find_element(:xpath, "/html/body/div/div/div/div/div[2]/div[1]/div").displayed?) rescue false; sleep 1 }
    sleep 2
  end

  end
end