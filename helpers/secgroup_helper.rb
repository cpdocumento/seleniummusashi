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

  def custom_rule(driver, res_secgroup, sec_rules)
    sleep 5  
    !60.times{ break if (driver.find_element(:css, "i.fa.fa-lock").displayed? rescue false); sleep 1 }
    driver.find_element(:css, "i.fa.fa-lock").click
    !60.times{ break if (driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ res_secgroup }\"]").displayed? rescue false); sleep 1 }    
    driver.find_element(:xpath, "//tr[@class=\"ng-scope\"]/td[normalize-space(text())=\"#{ res_secgroup }\"]/..//td[5]/div/button[1]").click
    !60.times{ break if (driver.find_element(:xpath, "//*[@id=\"optionsRulesCustom\"]")).displayed? rescue false; sleep 1 }
    driver.find_element(:xpath, "//*[@id='optionsRulesCustom']/span").click 
    addRule(driver, sec_rules)
    
    driver.find_element(:css, "body > div.modal.fade.dash-width-500.in > div > div > div.modal-footer.ng-scope > button.btn.btn-primary.ng-binding").click  
  end
  
  def addRule(driver, sec_rules)
    if sec_rules.length > 0 then
      sec_rules.each do |rule|
        driver.find_element(:name, "from_port").clear
        driver.find_element(:name, "from_port").send_keys(rule[:from])
        driver.find_element(:name, "to_port").clear
        driver.find_element(:name, "to_port").send_keys(rule[:to])
        driver.find_element(:name, "ip_range").clear
        driver.find_element(:name, "ip_range").send_keys(rule[:ip])
        driver.find_element(:xpath, "//select[@ng-model=\"newRule.ip_protocol\"]").click
        select = driver.find_element(:xpath, "//select[@ng-model=\"newRule.ip_protocol\"]")
        select.find_elements(:tag_name => "option").find do |option|
          if (option.text == rule[:protocol])
            option.click
          end
        end
        driver.find_element(:xpath, "//button[@ng-click=\"addRule()\"]").click
        sleep 2
      end
    end
  end
  
  end
end