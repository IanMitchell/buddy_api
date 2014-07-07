module BuddyAPI
  module User
    CREATE_PATH = '/users'
    LOGIN_PATH = '/users/login'

    # Public: TODO: Document
    def self.create(token, username, password, options = {})
      params = { userName: username, password: password }
      params.merge! options

      response = BuddyAPI.buddy_request(BuddyAPI::POST,
                                        CREATE_PATH,
                                        options: params,
                                        token: token)

      body = JSON.parse(response.body)

      case response.code
      when '401', '400'
        BuddyAPI.buddy_error(body)
      when '200'
        return body
      else
        raise UnknownResponseCode, "#{self}.#{__method__} does not handle response #{response.code}"
      end
    end

    # Public: TODO: Test, Document
    def self.login(token, username, password)
      params = { userName: username, password: password }
      response = BuddyAPI.buddy_request(BuddyAPI::POST,
                                        LOGIN_PATH,
                                        options: params,
                                        token: token)

      body = JSON.parse(response.body)

      case response.code
      when '401', '400'
        BuddyAPI.buddy_error(body)
      when '200'
        return body
      else
        raise UnknownResponseCode, "#{self}.#{__method__} does not handle response #{response.code}"
      end
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
