require 'yaml'

class TestHelper
  def self.configure_buddy
    app = YAML::load_file(File.join(__dir__, 'config.yml'))

    BuddyAPI.configure do |config|
      config.app_id = app['appID']
      config.app_key = app['appKey']
    end
  end

  def self.wipe_configuration
    BuddyAPI.configure do |config|
      config.app_id = nil
      config.app_key = nil
    end
  end
end
