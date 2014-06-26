module Configuration
  VALID_OPTIONS_KEYS    = [:app_id, :app_key, :tier].freeze

  attr_accessor *VALID_OPTIONS_KEYS

  def reset
    self.app_id = nil
    self.app_key = nil
    self.tier = :free
  end

  def configure
    yield self
  end
end
