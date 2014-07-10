module BuddyAPI
  module MetaData
    SET_PATH       = '/metadata' # + id
    INCREMENT_PATH = '/metadata/{id}/{key}/increment'
    GET_PATH       = '/metadata' # + id + key
    SEARCH_PATH    = '/metadata/app|' # + id
    DELETE_PATH    = '/metadata' # + id + key

    # Public: TODO: Test, Document
    def self.set(token, id, values, visibility, options)
      params =  {
                  keyValuePairs: values,
                  visibility: visibility,
                }
      params.merge! options

      response = BuddyAPI.buddy_request(BuddyAPI::POST,
                                        SET_PATH + "/#{id}",
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
    def self.increment(token, id, key, visibility, delta)
      path = INCREMENT_PATH.gsub('#{id', id.to_s)
                           .gsub('#{key}', key.to_s)

      params =  {
                  delta: delta,
                  visibility: visibility
                }

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
    def self.get(token, id, key, visibility)
      path = GET_PATH + "/#{id}/#{key}"

      params = { visibility: visibility }

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
    def self.search(token, id, visibility, location_range, options)
      params =  {
                  visibility: visibility,
                  locationRange: location_range
                }
      params.merge! options

      response = BuddyAPI.buddy_request(BuddyAPI::GET,
                                        SEARCH_PATH + "#{id}",
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

    # Public: TODO: Implement
    def delete(token, key, id, visibility)
      path = DELETE_PATH + "/#{id}/#{key}"

      params = { visibility: visibility }

      response = BuddyAPI.buddy_request(BuddyAPI::DELETE,
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
