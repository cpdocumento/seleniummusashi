module Common
  module FloatingIPHelper

  def attachIP(driver, instance_name, ip)
    wait = Selenium::WebDriver::Wait.new(:timeout => 180)
    
    wait.until { driver.find_element(:css, "i.fa.fa-lock").displayed? }
    driver.find_element(:css, "i.fa.fa-lock").click

    # click attach button of ip
    driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ ip }\"]/..//td/div/button[1]").click
    
    # select instance to attach to 
    wait.until { driver.find_element(:xpath, "//select[@ng-model=\"fip.instance_option\"]").displayed? }
    driver.find_element(:xpath, "//select[@ng-model=\"fip.instance_option\"]").click
    driver.find_element(:xpath, "//select[@ng-model=\"fip.instance_option\"]/option[normalize-space(text())=\"#{ instance_name }\"]").click
    driver.find_element(:xpath, "//div[3]/button[2]").click
     
    # wait until the IP is attached
    wait.until { !(driver.find_element(:xpath, "//select[@ng-model=\"fip.instance_option\"]").displayed?) }
    assert !180.times{ break if (driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ ip }\"]/..//td[3]").text == instance_name) rescue false; sleep 1 }, "Timeout. It is taking too long to attach IP to instance."
    puts "Helper: Successfully attached floating IP #{ ip } to instance #{ instance_name }"
  end

  def detachIP(driver, instance_name)
    wait = Selenium::WebDriver::Wait.new(:timeout => 180)
    
    wait.until { driver.find_element(:css, "i.fa.fa-lock").displayed? }
    driver.find_element(:css, "i.fa.fa-lock").click

    # click detach button of ip that is attached to instance
    wait.until { driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr[2]/td[2]").displayed? }
    wait.until { driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ instance_name }\"]/..//td[2]").displayed? }
    ip = driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ instance_name }\"]/..//td[2]").text
    driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ instance_name }\"]/..//td/div/button[1]").click
    
    # confirmation message
    wait.until { driver.find_element(:xpath, "//*[@id=\"dash-access\"]/div[2]").displayed? }
    driver.find_element(:xpath, "//*[@id=\"dash-access\"]/div[2]/div/button[1]").click
    
    # wait until the IP is detached
    assert !180.times{ break if (driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ ip }\"]/..//td/div/button[1]").text =~ /Attach/) rescue false; sleep 1 }, "Timeout. It is taking too long to detach the IP from instance."
    puts "Helper: Successfully detached an IP from instance #{ instance_name }"
  end

  def allocateIP(driver)
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
    
    wait.until { driver.find_element(:css, "i.fa.fa-lock").displayed? }
    driver.find_element(:css, "i.fa.fa-lock").click
    sleep 2
    wait.until { driver.find_element(:xpath, "//div[@id='dash-access']/div[3]/div[2]/button").displayed? }
    rows = driver.find_elements(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr").size
    driver.find_element(:xpath, "//div[@id='dash-access']/div[3]/div[2]/button").click
    wait.until { driver.find_element(:xpath, "//select[@ng-model=\"floating_ip.pool\"]").displayed? }
    driver.find_element(:css, "body > div.modal.fade.in > div > div > div.modal-footer.ng-scope > button.btn.btn-primary.ng-binding").click

    assert !60.times{ break if ((driver.find_elements(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr").size == (rows+1)) rescue false); sleep 1 }, "Unable to allocate an IP successfully."
    puts "Helper: Successfully allocated a floating IP"
  end

  def disallocateIP(driver, ip)
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
    
    wait.until { driver.find_element(:css, "i.fa.fa-lock").displayed? }
    driver.find_element(:css, "i.fa.fa-lock").click
    sleep 2
    !60.times{ break if (driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ ip }\"]").displayed? rescue false); sleep 1 }
    rows = driver.find_elements(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr").size
    driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ ip }\"]/..//td[4]/div/button[2]").click
    wait.until { driver.find_element(:link, "Release").displayed? }
    driver.find_element(:link, "Release").click
		sleep 2
    driver.find_element(:xpath, "(//button[@type='button'])[2]").click
    assert !60.times{ break if ((driver.find_elements(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr").size == (rows-1)) rescue false); sleep 1 }
    puts "Helper: Successfully released floating IP #{ ip }"
  end

  end
end
