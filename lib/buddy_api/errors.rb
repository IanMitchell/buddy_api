module BuddyAPI
  # Public: Raised when a Buddy API call is executed
  # without the proper Configuration keys set.
  class InvalidConfiguration < Exception; end

  # Public: Raised when this gem doesn't know how
  # to handle the response from a Buddy Platform
  # API call.
  class UnknownResponseCode < Exception; end

  # Public: Raised when a required parameter is missing
  # from a Buddy Platform API call.
  class ParameterMissingRequiredValue < Exception; end

  # Public: Raised when a parameter is formatted
  # incorrectly in a Buddy Platform API call.
  class ParameterIncorrectFormat < Exception; end
end
