module Common
  module InstanceHelper
  
  def createInstance(driver, name, size, image, secgroup, keypair)
    wait = Selenium::WebDriver::Wait.new(:timeout => 120)
    
    sleep 5
    # click launch instance button    
    wait.until { driver.find_element(:css, "i.fa.fa-hdd-o").displayed? }
    driver.find_element(:css, "i.fa.fa-hdd-o").click
    sleep 5
    driver.find_element(:xpath, "//*[@id=\"side-action\"]").click
    wait.until { driver.find_element(:xpath, "/html/body/div[3]/div/div").displayed? }
    
    # step 1
    driver.find_element(:name, "name").clear
    driver.find_element(:name, "name").send_keys(name)
    driver.find_element(:xpath, "//button[3]").click
    sleep 1
    # step 2
    driver.find_element(:xpath, "//*[@id=\"launchInstance\"]/div[2]/div/span/p[normalize-space(text())=\"#{ size }\"]/..//p[\"flavor ng-binding\"]").click
    driver.find_element(:xpath, "//button[3]").click
    sleep 1
    # step 3
    driver.find_element(:xpath, "//*[@id=\"launchInstance\"]/div[3]/table/tbody/tr/td[normalize-space(text())=\"#{ image }\"]").click
    driver.find_element(:xpath, "//button[3]").click
    sleep 1
    # step 4
    driver.find_element(:xpath, "//label[@ng-model=\"form.keypair_checked\"]").click
    driver.find_element(:xpath, "//button[@ng-disabled=\"!form.keypair_checked\"]").click
    driver.find_element(:xpath, "//li[normalize-space(text())=\"#{ keypair }\"]").click
    @driver.find_element(:xpath, "//button[3]").click
    sleep 1
    # step 5
    wait.until { driver.find_element(:xpath, "//td[normalize-space(text())=\"#{ name }\"]").displayed? }
    @driver.find_element(:xpath, "//button[3]").click   

    # wait until the status of instance is no longer BUILD
    !60.times{ break if !(driver.find_element(:xpath, "//div[@window-class=\"wizard-modal\"]").displayed? rescue false); sleep 1 }
    sleep 10
    assert !180.times{ break if (driver.find_element(:xpath, "//tr/td[@id=\"instance-name\"]/a[normalize-space(text())=\"#{ name }\"]/../..//td[4]").text =~ /ACTIVE/) rescue false; sleep 2 }, "Timeout. Instance is not ACTIVE within the wait time set."
    puts "Helper: Successfully created instance #{ name }"
  end
  
  def stopInstance(driver, instance_name)
    wait = Selenium::WebDriver::Wait.new(:timeout => 120)
    
    # go to instances page    
    wait.until { driver.find_element(:css, "i.fa.fa-hdd-o").displayed? }
    driver.find_element(:css, "i.fa.fa-hdd-o").click
    
    # go to instance details page
    assert !60.times{ break if (driver.find_element(:xpath, "//tr/td[@id=\"instance-name\"]/a[normalize-space(text())=\"#{ instance_name }\"]/../..//td[4]").text =~ /ACTIVE/) rescue false; sleep 2 }
    driver.find_element(:link, instance_name).click
    wait.until { driver.find_element(:xpath, "//ul[@ng-show=\"instance.actions\"]").displayed? }
    driver.find_element(:link, "  Stop").click
    
    # wait until instance status is SHUTOFF
    assert !180.times{ break if (driver.find_element(:xpath, "//*[@id=\"details-action\"]/table/tbody/tr[1]/td[2]").text =~ /SHUTOFF/) rescue false; sleep 2 }, "Timeout. Instance is still not in SHUTOFF state within the wait time set."
    puts "Helper: Successfully stopped instance #{ instance_name }"
  end
  
  def deleteInstance(driver, instance_name)
    wait = Selenium::WebDriver::Wait.new(:timeout => 120)
    sleep 2
    
    # go to instances page    
    wait.until { driver.find_element(:css, "i.fa.fa-hdd-o").displayed? }
    driver.find_element(:css, "i.fa.fa-hdd-o").click
    
    # go to instance details page
    sleep 2
    rows = driver.find_elements(:xpath, "//*[@id=\"instances-list\"]/tbody/tr").size
    assert !60.times{ break if (driver.find_element(:xpath, "//tr/td[@id=\"instance-name\"]/a[normalize-space(text())=\"#{ instance_name }\"]").displayed? ) rescue false; sleep 2 }, "Unable to find the instance on list."
    wait.until { driver.find_element(:link, instance_name).displayed? }
    driver.find_element(:link, instance_name).click
    wait.until { driver.find_element(:xpath, "//ul[@ng-show=\"instance.actions\"]").displayed? }
    driver.find_element(:link, "  Terminate").click
    
    # confirmation message
    wait.until { driver.find_element(:xpath, "//div[@ng-show=\"confirm.title\"]").displayed? }
    driver.find_element(:xpath, "//*[@id=\"dash-instances\"]/div[2]/div/button[1]").click
    
    assert !240.times{ break if (driver.find_elements(:xpath, "//*[@id=\"instances-list\"]/tbody/tr").size == (rows-1)) rescue false; sleep 2 }, "Timeout. Instance is taking too long to delete."
    puts "Helper: Successfully deleted instance #{ instance_name }"
  end
  
  def createSnapshot(driver, instance_name, snapshot_name)
    wait = Selenium::WebDriver::Wait.new(:timeout => 180)
    sleep 2
    
    # go to instances page    
    wait.until { driver.find_element(:css, "i.fa.fa-hdd-o").displayed? }
    driver.find_element(:css, "i.fa.fa-hdd-o").click
    
    # go to instance details page
    sleep 2
    assert !60.times{ break if (driver.find_element(:xpath, "//tr/td[@id=\"instance-name\"]/a[normalize-space(text())=\"#{ instance_name }\"]").displayed? ) rescue false; sleep 2 }, "Unable to find instance on list."
    wait.until { driver.find_element(:link, instance_name).displayed? }
    driver.find_element(:link, instance_name).click
    wait.until { driver.find_element(:xpath, "//ul[@ng-show=\"instance.actions\"]").displayed? }
    driver.find_element(:link, "  Snapshot").click

    wait.until { driver.find_element(:xpath, "/html/body/div[3]/div/div").displayed? }
    driver.find_element(:name, "name").clear
    driver.find_element(:name, "name").send_keys(snapshot_name)
    driver.find_element(:xpath, "//div[3]/button[2]").click
    wait.until { driver.find_element(:xpath, "//p[@ng-bind-html=\"alert.msgs\"]").displayed? }
    
    # wait for vol snap to finish creating
    sleep 2
    wait.until { driver.find_element(:css, "i.fa.fa-floppy-o").displayed? }
    driver.find_element(:css, "i.fa.fa-floppy-o").click
    sleep 5
    assert !120.times{ break if (driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr/td[normalize-space(text())=\"snapshot for #{ snapshot_name }\"]/..//td[normalize-space(text())=\"\"]/..//td[3]").text =~/available/) rescue false; sleep 3 }, "Timeout. Was not able to create a snapshot successfully."
    puts "Helper: Successfully snapshotted instance #{ instance_name }"
  end
  
  def deleteSnapshot(driver, snapshot_name)
    wait = Selenium::WebDriver::Wait.new(:timeout => 120)
    sleep 2
    # go to images page    
    wait.until { driver.find_element(:css, "i.fa.fa-copy").displayed? }
    driver.find_element(:css, "i.fa.fa-copy").click
    
    wait.until { driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table/tbody/tr/td[normalize-space(text())=\"#{ snapshot_name }\"]").displayed? }
    sleep 2
    rows = driver.find_elements(:xpath, "//*[@id=\"dv-main-content\"]/table/tbody/tr").size
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table/tbody/tr/td[normalize-space(text())=\"#{ snapshot_name }\"]/..//td/div/button").click
    wait.until { driver.find_element(:xpath, "//div[@ng-show=\"confirm.title\"]").displayed? }
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/div[2]/div/button[1]").click
    sleep 2
    assert !120.times{ break if (driver.find_elements(:xpath, "//*[@id=\"dv-main-content\"]/table/tbody/tr").size == (rows-1)) rescue false; sleep 1 }, "Timeout. Was not able to delete the snapshot successfully."
    puts "Helper: Successfully deleted snapshot #{ snapshot_name }"
  end
  
  end
end