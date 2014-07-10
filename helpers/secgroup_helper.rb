module Common
  module SecurityGroupHelper

  def create_secgroup(driver, res_secgroup="", common_description="")
    !60.times{ break if (driver.find_element(:css, "i.fa.fa-lock").displayed? rescue false); sleep 1 }
    driver.find_element(:css, "i.fa.fa-lock").click
		
    !60.times{ break if (driver.find_element(:xpath, "//div[@id='dash-access']/div[4]/div[2]/button").displayed? rescue false); sleep 1 }
    driver.find_element(:xpath, "//div[@id='dash-access']/div[4]/div[2]/button").click
    !60.times{ break if (driver.find_element(:name, "name").displayed? rescue false); sleep 1 }
    driver.find_element(:name, "name").clear
    driver.find_element(:name, "name").send_keys(res_secgroup)
    driver.find_element(:css, "textarea[name=\"description\"]").clear
    driver.find_element(:css, "textarea[name=\"description\"]").send_keys(common_description)
    driver.find_element(:xpath, "//div[3]/button[2]").click
		
    assert !60.times{ break if (driver.find_element(:css, "p.ng-scope.ng-binding > p").displayed? rescue false); sleep 1 }
  end

  def delete_secgroup(driver, res_secgroup)
    !60.times{ break if (driver.find_element(:css, "i.fa.fa-lock").displayed? rescue false); sleep 1 }
    driver.find_element(:css, "i.fa.fa-lock").click

    !60.times{ break if (driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ res_secgroup }\"]").displayed? rescue false); sleep 1 }
    driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ res_secgroup }\"]/../td[5]/div/button[2]").click
    driver.find_element(:link, "Delete").click
    !60.times{ break if (driver.find_element(:xpath, "(//button[@type='button'])[2]").displayed? rescue false); sleep 1 }
    driver.find_element(:xpath, "(//button[@type='button'])[2]").click

    assert !60.times{ break if (driver.find_element(:css, "p.ng-scope.ng-binding > p").displayed? rescue false); sleep 1 }
  end
	
  end
end
