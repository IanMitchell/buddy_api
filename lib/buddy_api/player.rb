module BuddyAPI
  module Player
    CREATE_PATH = '/games/players'
    GET_PATH    = '/games/players' # + id
    SEARCH_PATH = '/games/players' # + id
    UPDATE_PATH = ''
    DELETE_PATH = ''

    # Public: TODO: Test, Document
    def self.create(token, options = {})
      response = BuddyAPI.buddy_request(BuddyAPI::POST,
                                        CREATE_PATH,
                                        options: options,
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
    def self.get(token, id)
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
        raise UnknownResponseCode, BuddyAPI.error_message(self,
                                                          __method__,
                                                          response.code)
      end
    end

    # Public: TODO: Test, Document
    def self.search(token, location_range, options = {})
      params = { locationRange: location_range }
      params.merge! options

      response = BuddyAPI.buddy_request(BuddyAPI::GET,
                                        SEARCH_PATH,
                                        options: params,
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
    def self.update(token, id, options = {})
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
        raise UnknownResponseCode, BuddyAPI.error_message(self,
                                                          __method__,
                                                          response.code)
      end
    end

    # Public: TODO: Test, Document
    def self.delete(token, id)
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
        raise UnknownResponseCode, BuddyAPI.error_message(self,
                                                          __method__,
                                                          response.code)
      end
    end
  end
end
