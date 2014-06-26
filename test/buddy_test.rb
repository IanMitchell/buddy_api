require 'test/unit'
require 'test_helper'
require 'buddy_api'

class BuddyTest < Test::Unit::TestCase
  def test_valid_configuration
    TestHelper::wipe_configuration
    assert !BuddyAPI::valid_configuration?

    TestHelper::configure_buddy
    assert BuddyAPI::valid_configuration?
  end
end
