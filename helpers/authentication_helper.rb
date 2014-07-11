module Common
  module AuthenticationHelper
 
  def login(driver, username="", password="", expect_entry=true) 
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
    
    wait.until { driver.find_element(:xpath, "//input[@type='text']").displayed? }
    driver.find_element(:xpath, "//input[@type='text']").clear
    driver.find_element(:xpath, "//input[@type='text']").send_keys(username)
    driver.find_element(:xpath, "//input[@type='password']").clear
    driver.find_element(:xpath, "//input[@type='password']").send_keys(password)
    driver.find_element(:xpath, "//input[@value='Login']").click
      
    assert !60.times{ break if (driver.find_element(:xpath, "//*[@id=\"dash-mainbar\"]/div/div[2]/ul[2]/li[2]/a").displayed? rescue false); sleep 1 }
  end

  def logout(driver)
    driver.find_element(:link_text, "Logout").click
    
    assert !60.times{ break if (driver.find_element(:xpath, "//input[@type='text']").displayed? rescue false); sleep 1 }
  end

  end
end