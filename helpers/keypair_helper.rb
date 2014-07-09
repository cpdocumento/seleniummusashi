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
    driver.find_element(:css, "i.fa.fa-lock").click
    !60.times{ break if (@driver.find_element(:xpath, "//div[@id='dash-access']/table[3]/tbody/tr[2]/td").displayed? rescue false); sleep 1 }
    keypair_name = @driver.find_element(:xpath, "//div[@id='dash-access']/table[3]/tbody/tr[2]/td").text
		
    if "No available keypairs." != driver.find_element(:xpath, "//div[@id='dash-access']/table[3]/tbody/tr/td").text
      if "#{keypair_name}" == res_keypair
        !60.times{ break if (driver.find_element(:xpath, "//div[@id='dash-access']/table[3]/tbody/tr[2]/td[3]/div/button") rescue false); sleep 1 }
        driver.find_element(:xpath, "//div[@id='dash-access']/table[3]/tbody/tr[2]/td[3]/div/button").click
        !60.times{ break if (driver.find_element(:xpath, "//div[@id='dash-access']/div[2]/div").displayed? rescue false); sleep 1 }
        driver.find_element(:xpath, "(//button[@type='button'])[2]").click
      end
      assert !60.times{ break if (driver.find_element(:css, "p.ng-scope.ng-binding > p").displayed? rescue false); sleep 1 }
    end
  end
	
  end
end