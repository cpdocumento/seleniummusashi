module Common
  module UsersHelper

  def delete_member(driver, username)    
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
      
    wait.until { driver.find_element(:css, "i.fa.fa-group").displayed? }
    driver.find_element(:css, "i.fa.fa-group").click
    wait.until { driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ username }\"]").displayed? }
    rows = driver.find_elements(:xpath, "//*[@id=\"dv-main-content\"]/table/tbody/tr").size
    driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ username }\"]/..//button[2]").click
    driver.find_element(:xpath, "(//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ username }\"]/..//a[contains(text(),'Delete Member')])").click
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/div[2]/div/button[1]").click
    
    assert !60.times{ break if (driver.find_elements(:xpath, "//*[@id=\"dv-main-content\"]/table/tbody/tr").size == (rows-1)) rescue false; sleep 1 }, "Timeout. Was unable to delete the PM successfully."
  end
  
  def delete_pa(driver, username)
    wait = Selenium::WebDriver::Wait.new(:timeout => 180)
      
    wait.until { driver.find_element(:css, "i.fa.fa-group").displayed? }
    driver.find_element(:css, "i.fa.fa-group").click
    
    wait.until { driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table/tbody/tr/td[normalize-space(text())=\"#{ username }\"]").displayed? }  
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table/tbody/tr/td[normalize-space(text())=\"#{ username }\"]/..//td/div/button[2]").click
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table/tbody/tr/td[normalize-space(text())=\"#{ username }\"]/..//td/div/ul/li[2]/a").click
    wait.until { driver.find_element(:xpath, "//div[@ng-show=\"confirm.title\"]").displayed? }
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/div[2]/div/button[1]").click
  end

  end
end