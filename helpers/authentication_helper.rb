module Common
  module AuthenticationHelper
 
  def login(driver, username="", password="", expect_entry=true) 
    wait = Selenium::WebDriver::Wait.new(:timeout => 15)
    
    driver.find_element(:xpath, "//input[@type='text']").clear
    driver.find_element(:xpath, "//input[@type='text']").send_keys(username)
    driver.find_element(:xpath, "//input[@type='password']").clear
    driver.find_element(:xpath, "//input[@type='password']").send_keys(password)
      
    wait.until { driver.find_element(:xpath, "//*[@id=\"dash-mainbar\"]/div/div[2]/ul[2]/li[2]/a").displayed? }

  end

  def logout(driver)
    driver.find_element(:xpath, "//*[@id=\"dash-mainbar\"]/div/div[2]/ul[2]/li[2]/a").click   
  end

  end
end