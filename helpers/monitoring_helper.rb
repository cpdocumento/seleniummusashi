module Common
  module MonitoringHelper

	def update_settings(driver, warning, error)
		settings_links = [
			"//*[@id='monitoring-summary']/div[2]/div[1]/div[1]/a",
			"//*[@id='monitoring-summary']/div[2]/div[2]/div[1]/a",
			"//*[@id='monitoring-summary']/div[2]/div[3]/div[1]/a"
		]

		settings_links.each do |settings_link|
			update_threshold(driver, warning, error, settings_link)
		end
	end

	def update_threshold(driver, warning, error, settings_link)
		wait = Selenium::WebDriver::Wait.new(:timeout => 15)
    sleep 2
		driver.find_element(:xpath, "//*[@id='dash-sidebar']/ul/li[2]/a").click
 		!60.times{ break if (driver.find_element(:xpath, "//*[@id='SN_cpu']")).displayed? rescue false; sleep 2}
		
		driver.find_element(:xpath, settings_link).click
	  sleep 2
		!60.times{ break if (driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[1]/h4/span")).displayed? rescue false; sleep 2}
		
		#CPU settings 
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[3]/div[1]/div[3]/div[1]/form/div[1]/div[2]/div[1]/input").clear
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[3]/div[1]/div[3]/div[1]/form/div[1]/div[2]/div[1]/input").send_keys(warning)
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[3]/div[1]/div[3]/div[1]/form/div[2]/div[2]/div[1]/input").clear
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[3]/div[1]/div[3]/div[1]/form/div[2]/div[2]/div[1]/input").send_keys(error)
    
		#Memory Settings
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[3]/div[2]/div[3]/div[1]/form/div[1]/div[2]/div[1]/input").clear
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[3]/div[2]/div[3]/div[1]/form/div[1]/div[2]/div[1]/input").send_keys(warning)
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[3]/div[2]/div[3]/div[1]/form/div[2]/div[2]/div[1]/input").clear
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[3]/div[2]/div[3]/div[1]/form/div[2]/div[2]/div[1]/input").send_keys(error)
    
		#Storage Settings
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[3]/div[3]/div[3]/div[1]/form/div[1]/div[2]/div[1]/input").clear
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[3]/div[3]/div[3]/div[1]/form/div[1]/div[2]/div[1]/input").send_keys(warning)
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[3]/div[3]/div[3]/div[1]/form/div[2]/div[2]/div[1]/input").clear
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[3]/div[3]/div[3]/div[1]/form/div[2]/div[2]/div[1]/input").send_keys(error)
    
		#Update parameters
		driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[7]/button[1]").click
		
		!60.times{ break if (driver.find_element(:xpath, "//*[@id='monitoring-settings']/div[2]/div/div/p/p")).text == "Monitoring settings has been successfully updated." rescue false; sleep 2}
	end

  end
end