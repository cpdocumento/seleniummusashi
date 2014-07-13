module Common
  module VolumeHelper

  def createVolume(driver, name, description, size)
    wait = Selenium::WebDriver::Wait.new(:timeout => 180)
    
    # click create volume button
    wait.until { driver.find_element(:css, "i.fa.fa-floppy-o").displayed? }
    driver.find_element(:css, "i.fa.fa-floppy-o").click
    wait.until { driver.find_element(:xpath, "//button[normalize-space(text())=\"Create Volume\"]").displayed? }    
    driver.find_element(:xpath, "//*[@id=\"side-action\"]").click
    wait.until { driver.find_element(:xpath, "/html/body/div[3]/div/div").displayed? }
    
    # enter details and create
    driver.find_element(:id, "displayName").clear
    driver.find_element(:id, "displayName").send_keys(name)
    driver.find_element(:id, "displayDescription").clear
    driver.find_element(:id, "displayDescription").send_keys(description)
    driver.find_element(:id, "volumeSize").clear
    driver.find_element(:id, "volumeSize").send_keys(size)
    driver.find_element(:xpath, "//div[3]/button[2]").click
    
    # wait until the volume is no longer in creating status
    assert !180.times{ break if !(driver.find_element(:xpath, "//tr/td[normalize-space(text())=\"#{ name }\"]/..//td[4]").text =~ /creating/) rescue false; sleep 2 }, "Timeout. Volume is still creating."
    puts "Helper: Successfully created volume #{ name }"
  end

  def attachVolume(driver, vol_name, instance_name)
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
   
    # click attach option of volume
    wait.until { driver.find_element(:css, "i.fa.fa-floppy-o").displayed? }
    driver.find_element(:css, "i.fa.fa-floppy-o").click    
    wait.until { driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ vol_name }\"]/..//td[7]/div/button").displayed? }
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ vol_name }\"]/..//td[7]/div/button").click
    
    # select instance to attach to 
    wait.until { driver.find_element(:xpath, "//*[@id=\"attachVolume\"]/div/select").displayed? }
    driver.find_element(:xpath, "//*[@id=\"attachVolume\"]/div/select").click
    driver.find_element(:xpath, "//form[@id='attachVolume']/div/select/option[normalize-space(text())=\"#{ instance_name }\"]").click
    driver.find_element(:xpath, "//div[3]/button[2]").click
    
    # wait until the volume is no longer in attaching status
    wait.until { !(driver.find_element(:xpath, "//*[@id=\"attachVolume\"]/div/select").displayed?) }
    assert !180.times{ break if (driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ vol_name }\"]/..//td[4]").text =~ /in-use/) rescue false; sleep 2 }, "Timeout. Volume is taking too long to attach."
    puts "Helper: Successfully attached volume #{ vol_name } to instance"
  end
  
  def detachVolume(driver, vol_name)
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
   
    # click detach option of volume
    wait.until { driver.find_element(:css, "i.fa.fa-floppy-o").displayed? }
    driver.find_element(:css, "i.fa.fa-floppy-o").click    
    wait.until { driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ vol_name }\"]/..//td[7]/div/button").displayed? }
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ vol_name }\"]/..//td[7]/div/button").click
    
    # confirmation message
    wait.until { driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/div[2]").displayed? }
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/div[2]/div/button[1]").click
  
    # wait until the volume is no longer attached
    wait.until { driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/div[1]/div").displayed? }
    assert !180.times{ break if (driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ vol_name }\"]/..//td[4]").text =~ /available/) rescue false; sleep 2 }, "Timeout. Volume is taking too long to detach."
    puts "Helper: Successfully detached volume #{ vol_name }"
  end
  
  def deleteVolume(driver, vol_name)
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
   
    # click delete option of volume
    wait.until { driver.find_element(:css, "i.fa.fa-floppy-o").displayed? }
    driver.find_element(:css, "i.fa.fa-floppy-o").click    
    sleep 2
    # perform deletion
    wait.until { driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ vol_name }\"]").displayed? }
    rows = driver.find_elements(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr").size
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ vol_name }\"]/..//td/div/button[2]").click
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ vol_name }\"]/..//td/div/ul/li[2]/a").click
    sleep 2
    wait.until { driver.find_element(:xpath, "//div[@ng-show=\"confirm.title\"]").displayed? }
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/div[2]/div/button[1]").click

    assert !180.times{ break if (driver.find_elements(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr").size == (rows-1)) rescue false; sleep 2 }, "Timeout. Volume is taking too long to delete." 
    puts "Helper: Successfully deleted volume #{ vol_name }"
  end
  
  def deleteBootableVolume(driver, boot_volume)
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
   
    # click delete option of volume
    wait.until { driver.find_element(:css, "i.fa.fa-floppy-o").displayed? }
    driver.find_element(:css, "i.fa.fa-floppy-o").click    
    sleep 5
    # go through each row
    waitForProcessingVolumeSnapshots(driver)
    rows = driver.find_elements(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr").size
    rows_orig = rows
    while (rows>1) do
      name = driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr[#{ rows }]/td[1]").text
      desc = driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr[#{ rows }]/td[2]").text
      if (name==boot_volume && desc=="")
        driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr[#{ rows }]/td[5]/div/button[2]/span").click
        sleep 1
        driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr[#{ rows }]/td[5]/div/ul/li/a").click
        wait.until { driver.find_element(:xpath, "//div[@ng-show=\"confirm.title\"]").displayed? }
        driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/div[2]/div/button[1]").click
        wait.until { driver.find_elements(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr").size == (rows_orig - 1) }
        break
      else
        rows = rows -1
      end
    end
  end
  
  def deleteAllVolumeSnapshots(driver)
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
    wait.until { driver.find_element(:css, "i.fa.fa-floppy-o").displayed? }
    driver.find_element(:css, "i.fa.fa-floppy-o").click    
    sleep 5
    waitForProcessingVolumeSnapshots(driver)
    rows = driver.find_elements(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr").size
    rows.downto(2) do |i|
      driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr[#{ i }]/td[5]/div/button[2]/span").click
      sleep 2
      driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr[#{ i }]/td/div/ul/li/a").click
      sleep 2
      wait.until { driver.find_element(:xpath, "//div[@ng-show=\"confirm.title\"]").displayed? }
      driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/div[2]/div/button[1]").click
      wait.until { driver.find_elements(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr").size == (i - 1) }
    end
    puts "Helper: Successfully cleaned up volume snapshots"
  end
  
  def waitForProcessingVolumeSnapshots(driver)
    wait = Selenium::WebDriver::Wait.new(:timeout => 120)
    sleep 2
    rows = driver.find_elements(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr").size
    rows.downto(2) do |i|
      !120.times{ break if (driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[2]/tbody/tr[#{ i }]/td[3]").text == ("available" || "error")) rescue false; sleep 2 }
    end
  end
  
  end
end