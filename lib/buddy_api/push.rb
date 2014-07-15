module BuddyAPI
  module Push
    SEND_PATH           = '/notifications'
    RECORD_RECIEVE_PATH = '/notifications/received' # + id

    # Public: TODO: Test, Document
    def self.send(token, options = {})
      response = BuddyAPI.buddy_request(BuddyAPI::POST,
                                        SEND_PATH,
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
    def self.record_recieve(token, id)
      path = RECORD_RECIEVE_PATH + "/#{id}"

      response = BuddyAPI.buddy_request(BuddyAPI::POST,
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
