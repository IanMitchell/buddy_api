module BuddyAPI
  module Metric
    RECORD_PATH = '/metrics/events' # + key
    FINISH_PATH = '/metrics/events' # + id

    # Public: TODO: Implement
    def self.record(token, key, options)
      response = BuddyAPI.buddy_request(BuddyAPI::POST,
                                        RECORD_PATH + "/#{key}",
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

    # Public: TODO: Implement
    def self.finish(token, id, options)
      response = BuddyAPI.buddy_request(BuddyAPI::DELETE,
                                        FINISH_PATH + "/#{id}",
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
  end
end
