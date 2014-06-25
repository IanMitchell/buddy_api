require 'net/http'
require 'json'

require 'configuration'
require 'buddy_api/version'

require 'buddy_api/album'
require 'buddy_api/album_item'
require 'buddy_api/blob'
require 'buddy_api/checkin'
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

  # TODO: Document
  ROOT_URL = 'https://api.buddyplatform.com'

  # TODO: Document
  @@request_url = nil

  # TODO: Document
  @@request_counter = Array.new

  # TODO: Document
  @@tier = :free

  # TODO: Implement
  def init
  end

  # TODO: Implement
  def self.valid_configuration?
    !(self.app_id.nil? or self.app_key.nil?)
  end

  # TODO: Implement
  def self.register_device(platform, options = {})
    raise InvalidConfiguration, 'Buddy API is not configured' unless self.valid_configuration?

    uri = URI(request_url + '/devices')

    params = { appID: self.app_id, appKey: self.app_key, platform: platform }
    params.merge options

    response = Net::HTTP.post_form(uri, params)
    body = JSON.parse(response.body)

    case response.code
    when "400"
      raise Module.const_get("BuddyAPI::#{body['error']}"), "#{body['errorNumber']}: #{body['message']}"
    when "201"
      set_request_url(body['result']['serviceRoot']) if body['result']['serviceRoot']
      return body
    else
      raise UnknownResponseCode, "register_device does not handle response #{response.code}"
    end
  end

  # TODO: Implement
  def update_device
  end

  # TODO: Document
  def set_request_url(url)
    @@request_url = url
  end

  # TODO: Document
  def self.request_url
    @@request_url || ROOT_URL
  end

  # TODO: Document
  def increment_call_count
    update_request_counter
    @@request_counter << Time.now.strftime('%Y%m%d%H%M%S%L').to_i
  end

  # TODO: Document
  def get_call_count
    update_request_counter
    @@request_counter.count
  end

  # TODO: Document
  def update_request_counter
    @request_counter.each do |r|
      if r - Time.now.strftime('%Y%m%d%H%M%S%L').to_i > 1000
        @@request_counter.delete r
      end
    end
  end

  # TODO: Document
  def set_tier(tier)
    if tier.eql? :free or tier.eql? :pro or tier.eql? :enterprise
      @@tier = tier
    else
      raise ArgumentError, 'Tier must be one of [:free, :pro, :enterprise]'
    end
  end

  # TODO: Document
  def rate_capped?
    case @@tier
    when :free
      @@request_counter.count < 20
    when :pro
      @@request_counter.count < 40
    when :enterprise
      @@request_counter.count < 60
    end
  end

  # TODO: Document
  def requests_left
    case @@tier
    when :free
      20 - @@request_counter.count
    when :pro
      40 - @@request_counter.count
    when :enterprise
      60 - @@request_counter.count
    end
  end
end
