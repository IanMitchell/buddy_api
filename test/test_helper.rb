require 'yaml'

class TestHelper
  def self.configure_buddy
    app = YAML::load_file(File.join(__dir__, 'config.yml'))

    BuddyAPI.configure do |config|
      config.app_id = app['appID']
      config.app_key = app['appKey']
      config.tier = :free
    end
  end
end
