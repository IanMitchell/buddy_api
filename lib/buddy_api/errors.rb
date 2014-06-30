module BuddyAPI
  # Public: Raised when a Buddy API call is executed
  # without the proper Configuration keys set.
  class InvalidConfiguration < Exception; end

  # Public: Raised when this gem doesn't know how
  # to handle the response from a Buddy Platform
  # API call.
  class UnknownResponseCode < Exception; end

  # TODO: Document
  class UnknownError < Exception; end

  # Public: Raised when a required parameter is missing
  # from a Buddy Platform API call.
  class ParameterMissingRequiredValue < Exception; end

  # Public: Raised when a parameter is formatted
  # incorrectly in a Buddy Platform API call.
  class ParameterIncorrectFormat < Exception; end

  # Public: Raised when an access token is invalid
  # or expired.
  class AuthAccessTokenInvalid < Exception; end
end
