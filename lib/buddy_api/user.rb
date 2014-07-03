module BuddyAPI
  module User
    # Public: TODO: Document
    def self.create(token, username, password, options = {})
      raise InvalidConfiguration, 'Buddy API is not configured' unless BuddyAPI.valid_configuration?

      uri = URI(BuddyAPI.request_url + '/users')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      request = Net::HTTP::Post.new(uri.request_uri)
      request['Authorization'] = "Buddy #{token}"

      params = { 'userName' => username, 'password' => password }
      params.merge! options

      request.set_form_data(params)

      response = http.request(request)
      body = JSON.parse(response.body)

      BuddyAPI.increment_call_count

      case response.code
      when '401', '400'
        begin
          raise Module.const_get("BuddyAPI::#{body['error']}"), "#{body['errorNumber']}: #{body['message']}"
        rescue
          raise UnknownError, "Unknown Error encountered: #{body['error']}"
        end
      when '200'
        return body
      else
        raise UnknownResponseCode, "#{self}.#{__method__} does not handle response #{response.code}"
      end
    end

    # Public: TODO: Implement
    def login
    end

    # Public: TODO: Implement
    def social_login
    end

    # Public: TODO: Implement
    def logout
    end

    # Public: TODO: Implement
    def get
    end

    # Public: TODO: Implement
    def search
    end

    # Public: TODO: Implement
    def update
    end

    # Public: TODO: Implement
    def delete
    end

    # Public: TODO: Implement
    def reset_password_request
    end

    # Public: TODO: Implement
    def reset_password
    end
  end
end
