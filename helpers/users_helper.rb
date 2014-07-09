module Common
  module UsersHelper

  def delete_member(driver, username)    
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
      
    wait.until { driver.find_element(:css, "i.fa.fa-group").displayed? }
    driver.find_element(:css, "i.fa.fa-group").click
    wait.until { driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ username }\"]") }
    driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ username }\"]/..//button[2]").click
    driver.find_element(:xpath, "(//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ username }\"]/..//a[contains(text(),'Delete Member')])").click
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/div[2]/div/button[1]").click
  end

  end
end