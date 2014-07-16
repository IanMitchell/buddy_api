module BuddyAPI
  module Scoreboard
    CREATE_PATH = '/games/#{id}/scoreboards'
    GET_PATH    = '/games/#{gameId}/scoreboards' # + scoreBoardId
    SEARCH_PATH = '/games/#{gameId}/scoreboards'
    DELETE_PATH = '/games/#{gameId}/scoreboards' # + scoreboardId

    # Public: TODO: Test, Document
    def self.create(token, id, name, direction, count, options = {})
      path = CREATE_PATH.gsub '#{id}', id.to_s

      params =  {
                  name: name,
                  direction: direction,
                  scoreCount: count
                }
      params.merge! options

      response = BuddyAPI.buddy_request(BuddyAPI::POST,
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
    def self.get(token, game_id, scoreboard_id, sort_order = nil)
      path = GET_PATH.gsub '#{gameId}', game_id.to_s
      path += "/#{scoreboard_id}"

      params = { sortOrder: sort_order } unless sort_order.nil?

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
    def self.delete(token, game_id, scoreboard_id)
      path = DELETE_PATH.gsub '#{gameId}', game_id.to_s
      path += "/#{scoreboard_id}"

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
