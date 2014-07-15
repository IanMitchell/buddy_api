module BuddyAPI
  module AlbumItem
    CREATE_PATH   = '/albums/#{albumId}/items'
    GET_PATH      = '/albums/#{albumId}/items' # + itemId
    GET_FILE_PATH = '/albums/#{albumId}/items/#{itemId}/file'
    SEARCH_PATH   = '/albums/#{albumID}/items'
    UPDATE_PATH   = '/albums/#{albumId}/items' # + itemId
    DELETE_PATH   = '/albums/#{albumId}/items' # + itemId

    # Public: TODO: Test, Document
    def self.create(token, album_id, item_id, options = {})
      path = CREATE_PATH.gsub '#{albumId}', album_id.to_s

      params = { itemId: item_id }
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
    def self.get(token, album_id, item_id)
      path = GET_PATH.gsub '#{albumId}', album_id.to_s
      path += "/#{item_id}"

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
    def self.get_file(token, album_id, item_id)
      path = GET_FILE_PATH.gsub('#{albumId}', album_id.to_s)
                          .gsub('#{itemId}', item_id.to_s)

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
    def self.search(token, album_id, options = {})
      path = SEARCH_PATH.gsub '#{albumId}', album_id.to_s

      response = BuddyAPI.buddy_request(BuddyAPI::GET,
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

    # Public: TODO: Test, Document
    def self.update(token, album_id, item_id, options = {})
      path = GET_PATH.gsub '#{albumId}', album_id.to_s
      path += "/#{item_id}"

      response = BuddyAPI.buddy_request(BuddyAPI::PATCH,
                                        path
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
    def self.delete(token, album_id, item_id)
      path = GET_PATH.gsub '#{albumId}', album_id.to_s
      path += "/#{item_id}"

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
