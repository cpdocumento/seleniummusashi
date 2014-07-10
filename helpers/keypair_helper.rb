module Common
  module KeypairHelper

  def import_keypair(driver, res_keypair="", keypair_keys="")
    driver.find_element(:css, "i.fa.fa-lock").click
    !60.times{ break if (driver.find_element(:xpath, "//div[@id='dash-access']/div[5]/div[2]/button").displayed? rescue false); sleep 1 }
    driver.find_element(:xpath, "//div[@id='dash-access']/div[5]/div[2]/button").click
    !60.times{ break if (driver.find_element(:name, "name").displayed? rescue false); sleep 1 }
    driver.find_element(:name, "name").clear
    driver.find_element(:name, "name").send_keys(res_keypair)
    driver.find_element(:name, "keys").clear
    driver.find_element(:name, "keys").send_keys(keypair_keys)
    driver.find_element(:xpath, "//div[3]/button[2]").click

    assert !60.times{ break if (driver.find_element(:css, "p.ng-scope.ng-binding > p").displayed? rescue false); sleep 1 }
  end

  def delete_keypair(driver, res_keypair)		
    !60.times{ break if (driver.find_element(:css, "i.fa.fa-lock").displayed? rescue false); sleep 1 }
    driver.find_element(:css, "i.fa.fa-lock").click
    !60.times{ break if (driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ res_keypair }\"]").displayed? rescue false); sleep 1 }
    driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ res_keypair }\"]/../td[3]/div/button").click
    !60.times{ break if (driver.find_element(:xpath, "(//button[@type='button'])[2]").displayed? rescue false); sleep 1 }
    driver.find_element(:xpath, "(//button[@type='button'])[2]").click
  end
	
  end
end
