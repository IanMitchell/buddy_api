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
    sleep(1.1) if BuddyAPI.rate_capped?

    if count && BuddyAPI.requests_left < count
      sleep(1.1)
    end
  end

  # This depends on Device.register working
  def self.get_device_token
    check_rate_limit

    response = BuddyAPI::Device.register('Gem Test')
    response['result']['accessToken']
  end

  # This depends on Device.register and User.login working
  def self.get_user_token
    check_rate_limit
    token = get_device_token

    response = BuddyAPI::User.login(token, 'apiTest', 'password')
    response['result']['accessToken']
  end
end
