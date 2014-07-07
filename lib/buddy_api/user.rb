module BuddyAPI
  module User
    CREATE_PATH                 = '/users'
    LOGIN_PATH                  = '/users/login'
    SOCIAL_LOGIN_PATH           = '/users/login/social'
    LOGOUT_PATH                 = '/users/me/logout'
    GET_PATH                    = '/users' # + id
    SEARCH_PATH                 = '/users'
    UPDATE_PATH                 = '/users' # + id
    DELETE_PATH                 = '/users' # + id
    REQUEST_PASSWORD_RESET_PATH = '/users/password'
    RESET_PASSWORD_PATH         = '/users/password'

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

    # Public: TODO: Test, Document
    def social_login(token, provider, id, access_token)
      params =  {
                  identityProviderName: provider,
                  identityID: id,
                  identityAccessToken: access_token
                }
      response = BuddyAPI.buddy_request(BuddyAPI::POST,
                                        SOCIAL_LOGIN_PATH,
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
    def logout(token)
      response = BuddyAPI.buddy_request(BuddyAPI::POST,
                                        LOGOUT_PATH,
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
    def get(token, id)
      response = BuddyAPI.buddy_request(BuddyAPI::GET,
                                        GET_PATH + "/#{id}",
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
    def search(token, location_range, options)
      params = { locationRange: locationRange }
      params.merge! options

      response = BuddyAPI.buddy_request(BuddyAPI::GET,
                                        SEARCH_PATH,
                                        token: token,
                                        options: params)

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
    def update(token, id, options)
      response = BuddyAPI.buddy_request(BuddyAPI::PATCH,
                                        UPDATE_PATH + "/#{id}",
                                        token: token,
                                        options: options)

      body = JSON.parse(response.body)

      case response.code
      when '401', '400'
        BuddyAPI.buddy_error(body)
      when '200'
        return true
      else
        raise UnknownResponseCode, "#{self}.#{__method__} does not handle response #{response.code}"
      end
    end

    # Public: TODO: Test, Document
    def delete(token, id)
      response = BuddyAPI.buddy_request(BuddyAPI::DELETE,
                                        DELETE_PATH + "/#{id}",
                                        token: token)

      body = JSON.parse(response.body)

      case response.code
      when '401', '400'
        BuddyAPI.buddy_error(body)
      when '200'
        return true
      else
        raise UnknownResponseCode, "#{self}.#{__method__} does not handle response #{response.code}"
      end
    end

    # Public: TODO: Test, Document
    def reset_password_request(token, user_name, subject, body)
      params = { userName: user_name, subject: subject, body: body }

      response = BuddyAPI.buddy_request(BuddyAPI::POST,
                                        REQUEST_PASSWORD_RESET_PATH,
                                        token: token,
                                        options: params)

      body = JSON.parse(response.body)

      case response.code
      when '401', '400'
        BuddyAPI.buddy_error(body)
      when '200'
        return true
      else
        raise UnknownResponseCode, "#{self}.#{__method__} does not handle response #{response.code}"
      end
    end

    # Public: TODO: Test, Document
    def reset_password(token, user_name, reset_code, new_password)
      params =  {
                  userName: user_name,
                  resetCode: reset_code,
                  newPassword: new_password
                }

      response = BuddyAPI.buddy_request(BuddyAPI::PATCH,
                                        RESET_PASSWORD_PATH,
                                        token: token,
                                        options: params)

      body = JSON.parse(response.body)

      case response.code
      when '401', '400'
        BuddyAPI.buddy_error(body)
      when '200'
        return true
      else
        raise UnknownResponseCode, "#{self}.#{__method__} does not handle response #{response.code}"
      end
    end
  end
end
