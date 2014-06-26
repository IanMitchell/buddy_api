module BuddyAPI
  class Device

    # Public: Registers a device with Buddy. If a serviceRoot is set,
    # the gem will store the request url. For more information,
    # see http://buddyplatform.com/docs/Register%20Device
    #
    # platform - the name of the platform to register
    # options - The Hash options used to send additional data (default: {}):
    #           :pushToken      - The String for a platform specific token used
    #                             for push notifications (optional).
    #           :appVersion     - The String for the installed application
    #                             version (optional).
    #           :osVersion      - The String for the OS version (optional).
    #           :uniqueId       - The String for a uniqueId that can be used
    #                             by the application on the device (optional).
    #           :model          - The String for device model (optional).
    #           :connectionType - The String for network connection type.
    #                             Valid options are "Unknown", "Carrier" and
    #                             "Wifi" (optional).
    #           :location       - The String for the location value. Valid format
    #                             is <latitude>,<longitude> (optional).
    #
    # Examples
    #
    #   BuddyAPI::Device::register('Nokia Lumia 1020')
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
    # Raises BuddyAPI::InvalidConfiguration if appID and appKey aren't set.
    # Raises BuddyAPI::ParameterIncorrectFormat if a parameter format is incorrect.
    # Raises BuddyAPI::ParameterMissingRequiredValue if a required parameter is missing.
    # Raises BuddyAPI::UnknownResponseCode if response code is unexpected.
    def self.register(platform, options = {})
      raise InvalidConfiguration, 'Buddy API is not configured' unless BuddyAPI::valid_configuration?

      uri = URI(BuddyAPI::request_url + '/devices')

      params = { appID: BuddyAPI.app_id, appKey: BuddyAPI.app_key, platform: platform }
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

    # Public: TODO: Implement.
    def update
    end
  end
end
