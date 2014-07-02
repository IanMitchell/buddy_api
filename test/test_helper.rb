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

  # This depends on the requests_left method working.
  def self.check_rate_limit(count = nil)
    sleep(1) if BuddyAPI.rate_capped?

    if count && BuddyAPI.requests_left < count
      sleep(1)
    end
  end
end
