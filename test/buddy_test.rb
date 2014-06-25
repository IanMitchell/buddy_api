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

  def test_register_device
    TestHelper::configure_buddy

    response = BuddyAPI::register_device('Gem Test')
    assert_equal response['status'], 201

    assert_raises(BuddyAPI::ParameterMissingRequiredValue) { BuddyAPI::register_device("") }
  end
end
