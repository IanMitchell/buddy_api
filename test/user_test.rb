require 'test/unit'
require 'test_helper'
require 'buddy_api'
require 'securerandom'

class UserTest < Test::Unit::TestCase
  def test_create_success
    TestHelper.configure_buddy
    TestHelper.check_rate_limit
    token = TestHelper.get_device_token

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
    TestHelper.check_rate_limit
    token = TestHelper.get_device_token

    assert_raises(BuddyAPI::ParameterIncorrectFormat) do
      BuddyAPI::User.create(token, SecureRandom.hex(6), 'password', { 'gender' => 'none' })
    end
  end

  def test_create_missing_parameter
    TestHelper.configure_buddy
    TestHelper.check_rate_limit
    token = TestHelper.get_device_token

    assert_raises(BuddyAPI::ParameterMissingRequiredValue) do
      BuddyAPI::User.create(token, SecureRandom.hex(6), '')
    end
  end

  # If this is the first time running this test,
  # it will fail since it is creating a unique user.
  # All subsequent runs will pass.
  def test_create_duplicate_user
    TestHelper.configure_buddy
    TestHelper.check_rate_limit(2)
    token = TestHelper.get_device_token

    assert_raises(BuddyAPI::ItemAlreadyExists) do
      BuddyAPI::User.create(token, 'apiTest', 'password')
    end
  end

  def test_login_success
    TestHelper.configure_buddy
    TestHelper.check_rate_limit
    token = TestHelper.get_device_token

    assert BuddyAPI::User.login(token, 'apiTest', 'password')
  end

  def test_login_bad_token
    TestHelper.configure_buddy
    TestHelper.check_rate_limit

    assert_raises(BuddyAPI::AuthAccessTokenInvalid) do
      BuddyAPI::User.login('hi', 'apiTest', 'password')
    end
  end

  def test_login_bad_param
    TestHelper.configure_buddy
    TestHelper.check_rate_limit
    token = TestHelper.get_device_token

    assert_raises(BuddyAPI::AuthBadUsernameOrPassword) do
      BuddyAPI::User.login(token, 'apiTest', 'wrongPassword')
    end
  end

  def test_login_missing_param
    TestHelper.configure_buddy
    TestHelper.check_rate_limit
    token = TestHelper.get_device_token

    assert_raises(BuddyAPI::ParameterMissingRequiredValue) do
      BuddyAPI::User.login(token, '', 'wrongPassword')
    end
  end

  # TODO: test other user methods
end
