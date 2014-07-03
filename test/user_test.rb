require 'test/unit'
require 'test_helper'
require 'buddy_api'
require 'securerandom'

class UserTest < Test::Unit::TestCase
  def test_create_success
    TestHelper.configure_buddy
    TestHelper.check_rate_limit(2)

    response = BuddyAPI::Device.register('Gem Test')
    token = response['result']['accessToken']

    assert BuddyAPI::User.create(token, SecureRandom.hex(6), 'password')
  end

  def test_create_bad_token
    TestHelper.check_rate_limit

    assert_raises(BuddyAPI::AuthAccessTokenInvalid) do
      BuddyAPI::User.create('hi', SecureRandom.hex(6), 'password')
    end
  end

  def test_create_bad_parameter
    TestHelper.configure_buddy
    TestHelper.check_rate_limit(2)

    response = BuddyAPI::Device.register('Gem Test')
    token = response['result']['accessToken']

    assert_raises(BuddyAPI::ParameterIncorrectFormat) do
      BuddyAPI::User.create(token, SecureRandom.hex(6), 'password', { 'gender' => 'none' })
    end
  end

  # If this is the first time running this test,
  # it will fail since it is creating a unique user.
  # All subsequent runs will pass.
  def test_create_duplicate_user
    TestHelper.configure_buddy
    TestHelper.check_rate_limit(2)

    response = BuddyAPI::Device.register('Gem Test')
    token = response['result']['accessToken']

    assert_raises(BuddyAPI::ItemAlreadyExists) do
      BuddyAPI::User.create(token, 'apiTest', 'password')
    end
  end
end
