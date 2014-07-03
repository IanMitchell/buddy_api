require 'uri'
require 'net/https'

module BuddyAPI
  module Device
    # Public: Registers a Device with Buddy. If a serviceRoot is set,
    # the gem will store the request url. For more information,
    # see http://buddyplatform.com/docs/Register%20Device
    #
    # platform - the name of the platform to register
    # options - The Array options used to send additional data. Note that because
    #           this is submitted as an HTTP header, it must be in a format similar
    #           to { 'key' => 'value' }. (default: {}):
    #           'pushToken'      - The String for a platform specific token used
    #                             for push notifications (optional).
    #           'appVersion'     - The String for the installed application
    #                             version (optional).
    #           'osVersion'      - The String for the OS version (optional).
    #           'uniqueId'       - The String for a uniqueId that can be used
    #                             by the application on the device (optional).
    #           'model'          - The String for device model (optional).
    #           'connectionType' - The String for network connection type.
    #                             Valid options are "Unknown", "Carrier" and
    #                             "Wifi" (optional).
    #           'location'       - The String for the location value. Valid format
    #                             is <latitude>,<longitude> (optional).
    #
    # Examples
    #
    #   BuddyAPI::Device.register('Nokia Lumia 1020')
    #   # => {
    #   #     "status"=>201,
    #   #     "result"=>{
    #   #       "accessToken"=>"...",
    #   #       "accessTokenExpires"=>"/Date(1406312362452)/"
    #   #     },
    #   #     "request_id"=>"..."
    #   #    }
    #
    # Returns the response body Array.
    # Raises BuddyAPI::InvalidConfiguration if appID and appKey are not set.
    # Raises BuddyAPI::ParameterIncorrectFormat if a parameter format is incorrect.
    # Raises BuddyAPI::ParameterMissingRequiredValue if a required parameter is missing.
    # Raises BuddyAPI::UnknownError if a Buddy error is not recognized
    # Raises BuddyAPI::UnknownResponseCode if response code is unexpected.
    def self.register(platform, options = {})
      raise InvalidConfiguration, 'Buddy API is not configured' unless BuddyAPI.valid_configuration?

      uri = URI(BuddyAPI.request_url + '/devices')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      request = Net::HTTP::Post.new(uri.request_uri)
      params = { 'appID' => BuddyAPI.app_id, 'appKey' => BuddyAPI.app_key, 'platform' => platform }
      params.merge! options

      request.set_form_data(params)

      response = http.request(request)
      body = JSON.parse(response.body)

      BuddyAPI.increment_call_count

      case response.code
      when '400'
        begin
          raise Module.const_get("BuddyAPI::#{body['error']}"), "#{body['errorNumber']}: #{body['message']}"
        rescue
          raise UnknownError, "Unknown Error encountered: #{body['error']}"
        end
      when '201'
        set_request_url(body['result']['serviceRoot']) if body['result']['serviceRoot']
        return body
      else
        raise UnknownResponseCode, "#{self}.#{__method__} does not handle response #{response.code}"
      end
    end

    # Public: Updates a Device with Buddy. For more information
    # see http://buddyplatform.com/docs/Update%20Device
    #
    # token   - The authorization token returned by BuddyAPI::Device.register
    # options - The Array options used to send updated data. Note that because
    #           this is submitted as an HTTP header, it must be in a format similar
    #           to { 'key' => 'value' }. (default: {}):
    #           'location'       - The String for the location value. Valid format
    #                              is <latitude>,<longitude> (optional).
    #           'pushToken'      - The String for a platform specific token used
    #                              for push notifications (optional).
    #           'connectionType' - The String for network connection type.
    #                              Valid options are "Unknown", "Carrier" and
    #                              "Wifi" (optional).
    #           'isProduction'   - The Boolean for indicating if the installed
    #                              application is published and in
    #                              production (optional).
    #           'tag'            - The String to attach to this object (optional).
    #
    # Examples
    #
    #   BuddyAPI::Device.update('token', { 'location' => '50,50' })
    #   # => true
    #
    # Returns a Boolean indicating if successful.
    # Raises BuddyAPI::AuthAccessTokenInvalid if the authorization token
    #   is invalid or expired
    # Raises BuddyAPI::UnknownError if a Buddy error is not recognized
    # Raises BuddyAPI::UnknownResponseCode if response code is unexpected.
    def self.update(token, options = {})
      uri = URI(BuddyAPI.request_url + '/devices/current')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      request = Net::HTTP::Patch.new(uri.request_uri)
      request['Authorization'] = "Buddy #{token}"
      request.set_form_data(options)

      response = http.request(request)
      body = JSON.parse(response.body)

      BuddyAPI.increment_call_count

      case response.code
      when '401'
        begin
          raise Module.const_get("BuddyAPI::#{body['error']}"), "#{body['errorNumber']}: #{body['message']}"
        rescue
          raise UnknownError, "Unknown Error encountered: #{body['error']}"
        end
      when '200'
        return true
      else
        raise UnknownResponseCode, "#{self}.#{__method__} does not handle response #{response.code}"
      end
    end

    # Public: Registers a crash report with Buddy. For more information
    # see http://buddyplatform.com/docs/Crash%20Reports
    #
    # token      - The authorization token returned by BuddyAPI::Device.register
    # stackTrace - A string containing the call stack information for the crash.
    # options    - The Array options used to send additional data. Note that because
    #              this is submitted as an HTTP header, it must be in a format similar
    #              to { 'key' => 'value' }. (default: {}):
    #              'message'     - A message to include about the crash (optional).
    #              'methodName'  - The String name of the method where the crash
    #                              occurred (optional).
    #              'location'    - The String for the location value. Valid format
    #                              is <latitude>,<longitude> (optional).
    #              'tag'         - The String to attach to this object (optional).
    #
    # Examples
    #
    #   BuddyAPI::Device.crash_report('token',
    #                                 'BuddyAPI::ParameterIncorrectFormat',
    #                                 { 'location' => '50,50' })
    #   # => true
    #
    # Returns a Boolean indicating if successful.
    # Raises BuddyAPI::AuthAccessTokenInvalid if the authorization token
    #   is invalid or expired
    # Raises BuddyAPI::ParameterMissingRequiredValue if stackTrace is not
    #   specified.
    # Raises BuddyAPI::UnknownError if a Buddy error is not recognized
    # Raises BuddyAPI::UnknownResponseCode if response code is unexpected.
    def self.crash_report(token, stack_trace, options = {})
      uri = URI(BuddyAPI.request_url + '/devices/current/crashreports')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      request = Net::HTTP::Post.new(uri.request_uri)
      request['Authorization'] = "Buddy #{token}"
      request.set_form_data(options.merge({ 'stackTrace' => stack_trace }))

      response = http.request(request)
      body = JSON.parse(response.body)

      BuddyAPI.increment_call_count

      case response.code
      when '401'
        begin
          raise Module.const_get("BuddyAPI::#{body['error']}"), "#{body['errorNumber']}: #{body['message']}"
        rescue
          raise UnknownError, "Unknown Error encountered: #{body['error']}"
        end
      when '201'
        return true
      else
        raise UnknownResponseCode, "#{self}.#{__method__} does not handle response #{response.code}"
      end
    end
  end
end
