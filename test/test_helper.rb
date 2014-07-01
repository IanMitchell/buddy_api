require 'yaml'
require 'buddy_api'

class TestHelper
  def self.configure_buddy
    app = YAML.load_file(File.join(__dir__, 'config.yml'))

    BuddyAPI.configure do |config|
      config.app_id = app['appID']
      config.app_key = app['appKey']
      config.tier = :free
    end
  end

  # This depends on the rate_capped? method working.
  def self.check_rate_limit
    sleep(1.5) if BuddyAPI.rate_capped?
  end
end
