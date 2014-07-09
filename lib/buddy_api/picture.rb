module BuddyAPI
  module Picture
    CREATE_PATH = '/pictures'
    INFO_PATH   = '/pictures' # + id
    GET_PATH    = '/pictures/#{id}/file'
    SEARCH_PATH = '/pictures'
    UPDATE_PATH = '/pictures' # + id
    DELETE_PATH = '/pictures' # + id

    # Public: TODO: Test, Document
    def self.create(token, data, options)
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
    def self.info(token, id, size = nil)
      params = Hash.new
      params = { size: size } unless size.nil?

      response = BuddyAPI.buddy_request(BuddyAPI::GET,
                                        INFO_PATH + "/#{id}",
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
    def self.get(token, id, sig, size = nil)
      path = GET_PATH.gsub '#{id}', id.to_s

      params = { sig: sig }
      params[:size] = size unless size.nil?

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
  end
end
