require 'test/unit'
require 'test_helper'
require 'buddy_api'

class DeviceTest < Test::Unit::TestCase
  def test_register_configuration_check
    TestHelper::wipe_configuration
    assert_raises(BuddyAPI::InvalidConfiguration) { BuddyAPI::Device::register("") }
  end

  def test_register_success
    TestHelper::configure_buddy

    response = BuddyAPI::Device::register('Gem Test')

    # In actual code, case/when requires 201 be string,
    # but this can be int?
    assert_equal 201, response['status']
  end

  def test_register_missing_param
    TestHelper::configure_buddy
    assert_raises(BuddyAPI::ParameterMissingRequiredValue) { BuddyAPI::Device::register("") }
  end

  def test_register_bad_param
    TestHelper::configure_buddy

    assert_raises(BuddyAPI::ParameterIncorrectFormat) do
      r = BuddyAPI::Device::register('Gem Test', { 'location' => '5050' })
    end
  end

  def test_update_success
    TestHelper::configure_buddy
    response = BuddyAPI::Device::register('Gem Test')
    token = response['result']['accessToken']

    assert BuddyAPI::Device::update(token, { 'location' => '50,50' })
  end

  def test_update_bad_token
    assert_raises(BuddyAPI::AuthAccessTokenInvalid) do
     BuddyAPI::Device::update('hi', { 'location' => '50,50' })
   end
  end

  # NOTE: Currently there is a bug with Buddy. If you send an incorrectly
  # formatted parameter, the server responds with a 500 error.
  # This test currently accounts for it, and will need to be updated later.
  def test_update_bad_param
    TestHelper::configure_buddy
    response = BuddyAPI::Device::register('Gem Test')
    token = response['result']['accessToken']

    assert_raises(BuddyAPI::UnknownResponseCode) do
      BuddyAPI::Device::update(token, { 'location' => '[50,50]' })
    end
  end
end
