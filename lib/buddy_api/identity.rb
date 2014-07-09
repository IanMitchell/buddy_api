module BuddyAPI
  module Identity
    ADD_PATH    = '/users/me/identities' # + provider
    REMOVE_PATH = '/users/me/identities' # + provider, (+ id)
    FIND_PATH   = '/users/identities'    # + provider, (+ id)
    GET_PATH    = '/users/me/identities' # (+ provider)

    # Public: TODO: Test, Document
    def self.add(token, provider, id)
      params = { identityId: id }

      response = BuddyAPI.buddy_request(BuddyAPI::POST,
                                        ADD_PATH + "/#{provider}",
                                        options: params,
                                        token: token)

      body = JSON.parse(response.body)

      case response.code
      when '401', '400'
        BuddyAPI.buddy_error(body)
      when '200'
        return body['result']
      else
        raise UnknownResponseCode, BuddyAPI.error_message(self,
                                                          __method__,
                                                          response.code)
      end
    end

    # Public: TODO: Test, Document
    def self.remove(token, provider, id = nil)
      path = REMOVE_PATH + "/#{provider}"
      path += "/#{id}" unless id.nil?

      response = BuddyAPI.buddy_request(BuddyAPI::DELETE,
                                        path,
                                        token: token)

      body = JSON.parse(response.body)

      case response.code
      when '401', '400'
        BuddyAPI.buddy_error(body)
      when '200'
        return true
      else
        raise UnknownResponseCode, BuddyAPI.error_message(self,
                                                          __method__,
                                                          response.code)
      end
    end

    # Public: TODO: Test, Document
    def self.find(token, provider, id)
      path = FIND_PATH + "/#{provider}/#{id}"

      response = BuddyAPI.buddy_request(BuddyAPI::GET,
                                        path,
                                        token: token)

      body = JSON.parse(response.body)

      case response.code
      when '401', '400'
        BuddyAPI.buddy_error(body)
      when '200'
        return body
      else
        raise UnknownResponseCode, BuddyAPI.error_message(self,
                                                          __method__,
                                                          response.code)
      end
    end

    # Public: TODO: Test, Document
    def self.get(token, provider = nil)
      path = GET_PATH
      path += "/#{provider}" unless provider.nil?

      response = BuddyAPI.buddy_request(BuddyAPI::GET,
                                        path,
                                        token: token)

      body = JSON.parse(response.body)

      case response.code
      when '401', '400'
        BuddyAPI.buddy_error(body)
      when '200'
        return body
      else
        raise UnknownResponseCode, BuddyAPI.error_message(self,
                                                          __method__,
                                                          response.code)
      end
    end
  end
end
