require 'test/unit'
require 'test_helper'
require 'buddy_api'

class DeviceTest < Test::Unit::TestCase
  def test_configuration_check
    TestHelper::wipe_configuration
    assert_raises(BuddyAPI::InvalidConfiguration) { BuddyAPI::Device::register("") }
  end

  def test_register
    TestHelper::configure_buddy

    response = BuddyAPI::Device::register('Gem Test')
    assert_equal response['status'], 201

    assert_raises(BuddyAPI::ParameterMissingRequiredValue) { BuddyAPI::Device::register("") }
  end
end
