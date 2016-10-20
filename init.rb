require 'rake'
require 'pry'
require 'require_all'
require 'yaml'
require 'json'
require 'open-uri'
require_all 'src/**/*.rb'


class App
  class << self
    def root
      @@root ||= begin
        File.expand_path File.dirname(__FILE__)
      end
    end

    def config
      @@config ||= begin
        YAML.load_file(File.join(App.root, 'config/application.yml'))
      end
    end

    def logger
      @@logger ||= begin
        AppLogger.new
      end
    end
  end
end
