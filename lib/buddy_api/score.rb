module BuddyAPI
  module Score
    CREATE_PATH = '/games/#{gameId}/sessions/#{sessionId}/scores'

    # Public: TODO: Test, Document
    def create(token, game_id, session_id, score = nil, options = {})
      path = CREATE_PATH.gsub('#{gameId}', game_id.to_s)
                        .gsub('#{sessionId}', session_id.to_s)
      path += "?score=#{score}" unless score.nil?

      response = BuddyAPI.buddy_request(BuddyAPI::POST,
                                        path,
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
  end
end
