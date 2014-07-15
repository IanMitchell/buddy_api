module BuddyAPI
  module Location
    CREATE_PATH = '/locations'
    GET_PATH    = '/locations' # + id
    SEARCH_PATH = '/locations'
    UPDATE_PATH = '/locations' # + id
    DELETE_PATH = '/locations' # + id
    FLAG_PATH   = '/locations/#{id}/flag'

    # Public: TODO: Test, Document
    def self.create(token, name, location, description, category, options = {})
      params =  {
                  name: name,
                  location: location,
                  description: description,
                  category: category
                }
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

    # Public: TODO: Test, Document
    def self.flag(token, id, comment, reason)
      path = FLAG_PATH.gsub '#{id}', id.to_s

      params = { comment: comment, flagReason: reason }

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
  end
end
