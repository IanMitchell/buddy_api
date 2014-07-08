module BuddyAPI
  module UserList
    CREATE_PATH = '/users/lists'
    GET_PATH    = '/users/lists/#{id}/items'
    ADD_PATH    = '/users/lists/#{user_list_id}/items/#{id}'
    REMOVE_PATH = '/users/lists/#{user_list_id}/items/#{id}'
    LIST_PATH   = '/users/lists/#{id}/items'

    # Public: TODO: Test, Document
    def self.create(token, name)
      params = { name: name }

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
        raise UnknownResponseCode, BuddyAPI.error_message(self,
                                                          __method__,
                                                          response.code)
      end
    end

    # Public: TODO: Test, Document
    def self.get(token, id)
      path = GET_PATH.gsub '#{id}', id.to_s

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
    def self.add(token, user_list_id, id)
      path = ADD_PATH.gsub('#{user_list_id', user_list_id.to_s)
                     .gsub('#{id}', id.to_s)

      response = BuddyAPI.buddy_request(BuddyAPI::PUT,
                                        path,
                                        token: token)

      body = JSON.parse(response.body)

      case response.code
      when '401', '400'
        BuddyAPI.buddy_error(body)
      when '200'
        return body['result'].eql? true
      else
        raise UnknownResponseCode, BuddyAPI.error_message(self,
                                                          __method__,
                                                          response.code)
      end
    end

    # Public: TODO: Test, Document
    def self.remove(token, user_list_id, id)
      path = DELETE_PATH.gsub('#{user_list_id', user_list_id.to_s)
                        .gsub('#{id}', id.to_s)

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
    def self.list(token, id)
      path = LIST_PATH.gsub '#{id}', id.to_s

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
