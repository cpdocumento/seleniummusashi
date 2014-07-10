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

    def custom_rule(driver, res_secgroup)
      driver.find_element(:css, "i.fa.fa-lock").click
        
      !30.times{ break if (driver.find_element(:xpath, "//tr[@class='ng-binding']/td[normalize-space(text())=\'#{ res_secgroup }\'").displayed? rescue false); sleep 1 }
      driver.find_element(:xpath, "//*[@id='dash-access']/table[2]/tbody/tr[3]/td[5]/div/button[1]").click
      assert_equal(!!(driver.find_element(:xpath, "//*[@id='dash-access']/table[2]/tbody/tr[2]/td[1]")), true)
      !30.times{ breack if (driver.find_element(:id, "//*[@id='optionsRulesCommon']").displayed? rescue false); sleep 1}
      assert_equal(!!(driver.find_element(:xpath, "//*[@id='optionsRulesCommon']")), true)

      driver.find_element(:xpath, "//*[@id='optionsRulesCustom']/span").click
      assert_equal(!!(driver.find_element(:xpath, "//*[@id='optionsRulesCustom']/span")), true)
  

        sec_rules = [ {from:443, to:443, ip:"0.0.0.0/0"} ]

        sec_rules.each do |rule|
          from = rule [:from]
            to = rule [:to]
            ip = rule [:ip]

            add_rule(driver, res_secgroup, from, to, ip)
        end

      driver.find_element(:css, "body > div.modal.fade.dash-width-500.in > div > div > div.modal-footer.ng-scope > button.btn.btn-primary.ng-binding").click
    end


    def add_rule(driver, res_secgroup, from, to, ip)
        wait = Selenium::WebDriver::Wait.new(:timeout => 60)
        
        driver.find_element(:name, "from_port").clear
        driver.find_element(:name, "from_port").send_keys(from)
        driver.find_element(:name, "to_port").clear
        driver.find_element(:name, "to_port").send_keys(to)
        driver.find_element(:name, "ip_range").clear
        driver.find_element(:name, "ip_range").send_keys(ip)
        driver.find_element(:css, "body > div.modal.fade.dash-width-500.in > div > div > div.modal-body.ng-scope > form > table > tbody > tr > td.align-right > button").click
    end
  
  end
end
