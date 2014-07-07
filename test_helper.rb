current_directory = File.expand_path(File.dirname(__FILE__) )

require "rubygems"
# require "test/unit"
require 'minitest'
require "minitest/autorun"
require "selenium-webdriver"
require "sqlite3"
Dir[current_directory + "/helpers/*.rb"].each {|ruby| require ruby }
require "yaml"

class Data
  class << self
    attr_accessor :config

    def configure
      self.config ||= Data::Configuration.new
      yield(config)
    end
  end


  class Configuration
    attr_accessor :test_data, :setup
    
    def yaml(name)
      current_directory = File.expand_path(File.dirname(__FILE__))
      YAML::load_file(current_directory + "/helpers/config/#{name}.yml")
    end
  end

end

Data.configure do |config|
  config.test_data = config.yaml("test_data")
  config.setup = config.yaml("setup")
end