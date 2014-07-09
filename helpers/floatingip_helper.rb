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
    wait.until { (driver.find_element(:xpath, "//*[@id=\"dash-access\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ ip }\"]/..//td[3]").text == instance_name) rescue false; sleep 1 }
  end


  end
end