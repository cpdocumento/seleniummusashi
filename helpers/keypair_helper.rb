module Common
  module KeypairHelper

  def import_keypair(driver, res_keypair="", keypair_keys="")
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
    !60.times{ break if (driver.find_element(:css, "i.fa.fa-lock").displayed? rescue false); sleep 1 }
    driver.find_element(:css, "i.fa.fa-lock").click
    !60.times{ break if (driver.find_element(:xpath, "//div[@id='dash-access']/div[5]/div[2]/button").displayed? rescue false); sleep 1 }
    sleep 2
    rows = driver.find_elements(:xpath, "//*[@id=\"dash-access\"]/table[3]/tbody/tr").size
    driver.find_element(:xpath, "//div[@id='dash-access']/div[5]/div[2]/button").click
    !60.times{ break if (driver.find_element(:name, "name").displayed? rescue false); sleep 1 }
    driver.find_element(:name, "name").clear
    driver.find_element(:name, "name").send_keys(res_keypair)
    driver.find_element(:name, "keys").clear
    driver.find_element(:name, "keys").send_keys(keypair_keys)
    driver.find_element(:xpath, "//div[3]/button[2]").click

    sleep 2
    assert !120.times{ break if (driver.find_elements(:xpath, "//*[@id=\"dash-access\"]/table[3]/tbody/tr").size == (rows+1)) rescue false; sleep 1 }, "Timeout. Was unable to import a keypair successfully."
    puts "Helper: Successfully imported keypair #{ res_keypair }"
  end

  def delete_keypair(driver, res_keypair)		
    !60.times{ break if (driver.find_element(:css, "i.fa.fa-lock").displayed? rescue false); sleep 1 }
    driver.find_element(:css, "i.fa.fa-lock").click
    !60.times{ break if (driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ res_keypair }\"]").displayed? rescue false); sleep 1 }
    sleep 2
    rows = driver.find_elements(:xpath, "//*[@id=\"dash-access\"]/table[3]/tbody/tr").size
    driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ res_keypair }\"]/../td[3]/div/button").click
    !60.times{ break if (driver.find_element(:xpath, "(//button[@type='button'])[2]").displayed? rescue false); sleep 1 }
    driver.find_element(:xpath, "(//button[@type='button'])[2]").click
    
    sleep 2
    assert !120.times{ break if (driver.find_elements(:xpath, "//*[@id=\"dash-access\"]/table[3]/tbody/tr").size == (rows-1)) rescue false; sleep 1 }, "Timeout. Was unable to delete a keypair successfully."    
    puts "Helper: Successfully deleted keypair #{ res_keypair }"
  end
	
  end
end
