require 'net/http'
require 'json'

require 'configuration'
require 'buddy_api/version'

require 'buddy_api/album'
require 'buddy_api/album_item'
require 'buddy_api/blob'
require 'buddy_api/checkin'
require 'buddy_api/device'
require 'buddy_api/errors'
require 'buddy_api/game'
require 'buddy_api/identity'
require 'buddy_api/location'
require 'buddy_api/message'
require 'buddy_api/metadata'
require 'buddy_api/metric'
require 'buddy_api/picture'
require 'buddy_api/player'
require 'buddy_api/push'
require 'buddy_api/score'
require 'buddy_api/scoreboard'
require 'buddy_api/session'
require 'buddy_api/user'
require 'buddy_api/user_list'
require 'buddy_api/video'

module BuddyAPI
  extend Configuration

  # Public: Default endpoint for a Buddy Platform API call.
  ROOT_URL = 'https://api.buddyplatform.com'

  # Public: Calls/Second rate-limit cap for Free tier.
  FREE_TIER_CAP = 20

  # Public: Calls/Second rate-limit cap for Pro tier.
  PRO_TIER_CAP = 40

  # Public: Calls/Second rate-limit cap for Enterprise tier.
  ENTERPRISE_TIER_CAP = 60

  # Private: Stored serviceEndpoint returned from Device::register.
  @@request_url = nil

  # Private: Tracks the most recent API calls for rate limiting information.
  @@request_counter = Array.new

  # Public: TODO: Implement
  def init
  end

  # Public: TODO: Implement
  def self.valid_configuration?
    plan = (self.tier.eql? :free or self.tier.eql? :pro or self.tier.eql? :enterprise)
    credentials = !(self.app_id.nil? or self.app_key.nil?)

    (plan and credentials)
  end

  # Public: TODO: Document
  def self.set_request_url(url)
    @@request_url = url
  end

  # Public: TODO: Document
  def self.request_url
    @@request_url || ROOT_URL
  end

  # Public: TODO: Document
  def self.increment_call_count
    update_request_counter
    @@request_counter << Time.now.strftime('%Y%m%d%H%M%S%L').to_i
  end

  # Public: TODO: Document
  def self.call_count
    update_request_counter
    @@request_counter.count
  end

  # Public: TODO: Document
  def self.update_request_counter
    @@request_counter.each do |r|
      if Time.now.strftime('%Y%m%d%H%M%S%L').to_i - r > 1000
        @@request_counter.delete r
      end
    end
  end

  # Public: TODO: Document
  def rate_capped?
    requests_left.eql? 0
  end

  # Public: TODO: Document
  def requests_left
    raise InvalidConfiguration, 'Buddy API is not configured' unless valid_configuration?

    update_request_counter

    case @@tier
    when :free
      FREE_TIER_CAP - @@request_counter.count
    when :pro
      PRO_TIER_CAP - @@request_counter.count
    when :enterprise
      ENTERPRISE_TIER_CAP - @@request_counter.count
    end
  end
end
