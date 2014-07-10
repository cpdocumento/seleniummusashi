module Common
  module InstanceHelper
  
  def createInstance(driver, name, size, image, secgroup, keypair)
    wait = Selenium::WebDriver::Wait.new(:timeout => 120)
    
    # click launch instance button    
    wait.until { driver.find_element(:css, "i.fa.fa-hdd-o").displayed? }
    driver.find_element(:css, "i.fa.fa-hdd-o").click
    driver.find_element(:xpath, "//*[@id=\"side-action\"]").click
    wait.until { driver.find_element(:xpath, "/html/body/div[3]/div/div").displayed? }
    
    # step 1
    driver.find_element(:name, "name").clear
    driver.find_element(:name, "name").send_keys(name)
    driver.find_element(:xpath, "//button[3]").click
    
    # step 2
    driver.find_element(:xpath, "//*[@id=\"launchInstance\"]/div[2]/div/span/p[normalize-space(text())=\"#{ size }\"]/..//p[\"flavor ng-binding\"]").click
    driver.find_element(:xpath, "//button[3]").click
    
    # step 3
    driver.find_element(:xpath, "//*[@id=\"launchInstance\"]/div[3]/table/tbody/tr/td[normalize-space(text())=\"#{ image }\"]").click
    driver.find_element(:xpath, "//button[3]").click
    
    # step 4
    driver.find_element(:xpath, "//label[@ng-model=\"form.keypair_checked\"]").click
    driver.find_element(:xpath, "//button[@ng-disabled=\"!form.keypair_checked\"]").click
    driver.find_element(:xpath, "//li[normalize-space(text())=\"#{ keypair }\"]").click
    @driver.find_element(:xpath, "//button[3]").click
    
    # step 5
    wait.until { driver.find_element(:xpath, "//td[normalize-space(text())=\"#{ name }\"]").displayed? }
    @driver.find_element(:xpath, "//button[3]").click   

    # wait until the status of instance is no longer BUILD
    assert !60.times{ break if !(driver.find_element(:xpath, "//div[@window-class=\"wizard-modal\"]").displayed? rescue false); sleep 1 }
    sleep 10
    assert !120.times{ break if !(driver.find_element(:xpath, "//tr/td[@id=\"instance-name\"]/a[normalize-space(text())=\"#{ name }\"]/../..//td[4]").text =~ /BUILD/) rescue false; sleep 2 }
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
    assert !120.times{ break if (driver.find_element(:xpath, "//*[@id=\"details-action\"]/table/tbody/tr[1]/td[2]").text =~ /SHUTOFF/) rescue false; sleep 2 }
  end
  
  def deleteInstance(driver, instance_name)
    wait = Selenium::WebDriver::Wait.new(:timeout => 120)
    sleep 2
    
    # go to instances page    
    wait.until { driver.find_element(:css, "i.fa.fa-hdd-o").displayed? }
    driver.find_element(:css, "i.fa.fa-hdd-o").click
    
    # go to instance details page
    sleep 2
    assert !60.times{ break if (driver.find_element(:xpath, "//tr/td[@id=\"instance-name\"]/a[normalize-space(text())=\"#{ instance_name }\"]").displayed? ) rescue false; sleep 2 }
    wait.until { driver.find_element(:link, instance_name).displayed? }
    driver.find_element(:link, instance_name).click
    wait.until { driver.find_element(:xpath, "//ul[@ng-show=\"instance.actions\"]").displayed? }
    driver.find_element(:link, "  Terminate").click
    
    # confirmation message
    wait.until { driver.find_element(:xpath, "//div[@ng-show=\"confirm.title\"]").displayed? }
    driver.find_element(:xpath, "//*[@id=\"dash-instances\"]/div[2]/div/button[1]").click
  end
  
  end
end