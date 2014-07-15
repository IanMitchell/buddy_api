module BuddyAPI
  module Session
    CREATE_PATH = '/games/#{id}/sessions'
    GET_PATH    = '/games/#{gameId}/sessions' # + id
    SEARCH_PATH = '/games/#{gameId}/sessions'
    UPDATE_PATH = '/games/#{gameId}/sessions' # + sessionId
    DELETE_PATH = '/games/#{gameId}/sessions' # + sessionId

    # Public: TODO: Test, Document
    def self.create(token, id, name, options = {})
      path = CREATE_PATH.gsub '#{id}', id.to_s

      params =  { name: name }
      params.merge! options

      response = BuddyAPI.buddy_request(BuddyAPI::POST,
                                        path
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
    def self.get(token, game_id, session_id)
      path = GET_PATH.gsub '#{gameId}', game_id.to_s
      path += "/#{session_id}"

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
    def self.search(token, game_id, location_range, options = {})
      path = SEARCH_PATH.gsub '#{gameId}', game_id.to_s

      params = { locationRange: location_range }
      params.merge! options

      response = BuddyAPI.buddy_request(BuddyAPI::GET,
                                        path,
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
    def self.update(token, game_id, session_id, options = {})
      path = UPDATE_PATH.gsub '#{gameId}', game_id.to_s
      path += "/#{session_id}"

      response = BuddyAPI.buddy_request(BuddyAPI::PATCH,
                                        path,
                                        options: options,
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
    def self.delete(token, game_id, session_id)
      path = DELETE_PATH.gsub '#{gameId}', game_id.to_s
      path += "/#{session_id}"

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
  end
end
