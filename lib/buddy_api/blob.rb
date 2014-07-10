module BuddyAPI
  module Blob
    CREATE_PATH   = '/blobs'
    GET_PATH      = '/blobs' # + id
    GET_FILE_PATH = '/blobs/#{id}/file'
    SEARCH_PATH   = '/blobs'
    UPDATE_PATH   = '/blobs' # + id
    DELETE_PATH   = ''

    # Public: TODO: Test, Document
    def self.create(token, data, option)
      params = { data: data }
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
    def self.get_file(token, id, sig)
      path = GET_FILE_PATH.gsub '#{id}', id.to_s
      params = { sig: sig }

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
    def self.search(token, options)
      response = BuddyAPI.buddy_request(BuddyAPI::GET,
                                        SEARCH_PATH,
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
    def self.update(token, id, options)
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

    # Public: TODO: Implement
    def delete(token, password)
    end
  end
end
