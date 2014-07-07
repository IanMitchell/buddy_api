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
  FREE_TIER_CAP       = 20

  # Public: Calls/Second rate-limit cap for Pro tier.
  PRO_TIER_CAP        = 40

  # Public: Calls/Second rate-limit cap for Enterprise tier.
  ENTERPRISE_TIER_CAP = 60

  # Private: Stored serviceEndpoint returned from Device.register.
  @@request_url     = nil

  # Private: Tracks the most recent API calls for rate limiting information.
  @@request_counter = Array.new

  # Public: Identifier for a GET request
  GET    = 0

  # Public: Identifier for a PATCH request
  PATCH  = 1

  # Public: Identifier for a POST request
  POST   = 2

  # Public: Identifier for a DELETE request
  DELETE = 3

  # Public: Identifier for a PUT request
  PUT    = 4

  # Public: Determines if the configuration has been correctly set.
  # This is used by the Gem internally, but is available if needed.
  #
  # Examples
  #
  #   BuddyAPI.valid_configuration?
  #   # => true
  #
  # Returns a Boolean
  def self.valid_configuration?
    plan = (self.tier.eql?(:free) || self.tier.eql?(:pro) || self.tier.eql?(:enterprise))
    credentials = !(self.app_id.nil? || self.app_key.nil?)

    plan && credentials
  end

  # Public: Sets the Buddy endpoint to use when sending a request.
  # This is an optional return when you register a device
  # (See BuddyAPI::Device.register).
  #
  # Examples
  #
  #   BuddyAPI.set_request_url('api-2.buddyplatform.com')
  #   # => 'api-2.buddyplatform.com'
  #
  # Returns a String
  def self.set_request_url(url)
    @@request_url = url
  end

  # Public: Determines the current Buddy endpoint to use when sending
  # a request to Buddy.
  #
  # Examples
  #
  #   BuddyAPI.request_url
  #   # => 'api-2.buddyplatform.com'
  #
  # Returns a String
  def self.request_url
    @@request_url || ROOT_URL
  end

  # Public: Records a call against Buddy at the current timestamp in milliseconds.
  # This is called automatically by all wrapper methods, but is available
  # if necessary. Requests older than 1 second are automatically purged
  # beforehand, as per Buddy limitations.
  #
  # Examples
  #
  #   BuddyAPI.increment_call_count
  #   # => [20140701220117530]
  #
  # Returns the updated Array
  def self.increment_call_count
    update_request_counter
    @@request_counter << Time.now.strftime('%Y%m%d%H%M%S%L').to_i
  end

  # Public: Determines the amount of calls you've made against the BuddyAPI
  # in the past 1 second. Requests older than 1 second are automatically purged
  # beforehand, as per Buddy limitations.
  #
  # Examples
  #
  #   BuddyAPI.call_count
  #   # => 18
  #
  # Returns an Integer
  def self.call_count
    update_request_counter
    @@request_counter.count
  end

  # Public: Refreshes the rate limit counter, removing all requests
  # older than 1 second. It is recommended to let the Gem handle this,
  # but is available if necessary.
  #
  # Examples
  #
  #   BuddyAPI.update_request_counter
  #   # => [20140701215728342, 20140701215728343]
  #
  # Returns the updated Array
  def self.update_request_counter
    @@request_counter.delete_if do |r|
      Time.now.strftime('%Y%m%d%H%M%S%L').to_i - r > 1_000
    end
  end

  # Public: Determines if you have hit the requests per second rate limit
  # imposed by Buddy. Requests older than 1 second are automatically purged
  # beforehand, as per Buddy limitations.
  #
  # Examples
  #
  #   BuddyAPI.rate_capped?
  #   # => false
  #
  # Returns a Boolean
  # Raises BuddyAPI::InvalidConfiguration if tier is not set.
  def self.rate_capped?
    requests_left.eql? 0
  end

  # Public: Determines the requests you have left until you hit the rate limit.
  # Requests older than 1 second are automatically purged beforehand, as per
  # Buddy limitations.
  #
  # Examples
  #
  #   BuddyAPI.requests_left
  #   # => 4
  #
  # Returns an Integer
  # Raises BuddyAPI::InvalidConfiguration if tier is not set.
  def self.requests_left
    raise InvalidConfiguration, 'Buddy API is not configured' unless valid_configuration?

    update_request_counter

    case self.tier
    when :free
      FREE_TIER_CAP - @@request_counter.count
    when :pro
      PRO_TIER_CAP - @@request_counter.count
    when :enterprise
      ENTERPRISE_TIER_CAP - @@request_counter.count
    end
  end

  # Public: Sends a request to Buddy. It is
  # recommended to let the Gem handle this, but is
  # available if necessary.
  #
  # Examples
  #
  #   BuddyAPI.buddy_request(BuddyAPI::POST, REGISTER_PATH)
  #   # => #<Net::HTTPOK:0x007f870b12c908>
  #
  # Returns the HTTP Response
  def self.buddy_request(type, url, options:  {}, token: nil)
    unless BuddyAPI.valid_configuration?
      raise InvalidConfiguration, 'Buddy API is not configured'
    end

    uri = URI(BuddyAPI.request_url + url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    case type
    when POST
      request = Net::HTTP::Post.new(uri.request_uri)
    when PATCH
      request = Net::HTTP::Patch.new(uri.request_uri)
    end

    request['Authorization'] = "Buddy #{token}" unless token.nil?
    request.set_form_data(options)

    BuddyAPI.increment_call_count
    response = http.request(request)
  end

  # Public: Handles a Buddy Exception. It is recommended
  # to let the Gem handle this, but is available if necessary.
  #
  # Examples
  #
  #   BuddyAPI.buddy_error(json_body)
  #   # => BuddyAPI::ParameterIncorrectFormat
  #
  # Returns Nothing
  # Raises a variety of Buddy Errors
  # Raises UnknownError if Buddy Error not defined in Gem
  def self.buddy_error(body)
    begin
      raise Module.const_get("BuddyAPI::#{body['error']}"), "#{body['errorNumber']}: #{body['message']}"
    rescue
      raise UnknownError, "Unknown Error encountered: #{body['error']}"
    end
  end
end
