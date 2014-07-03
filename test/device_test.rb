require 'test/unit'
require 'test_helper'
require 'buddy_api'

class DeviceTest < Test::Unit::TestCase
  def test_register_configuration_check
    BuddyAPI.reset
    sleep(1.1)

    assert_raises(BuddyAPI::InvalidConfiguration) { BuddyAPI::Device.register('') }
  end

  def test_register_success
    TestHelper.configure_buddy
    TestHelper.check_rate_limit

    response = BuddyAPI::Device.register('Gem Test')

    # In actual code, case/when requires 201 be string,
    # but this can be int?
    assert_equal 201, response['status']
  end

  def test_register_missing_param
    TestHelper.configure_buddy
    TestHelper.check_rate_limit

    assert_raises(BuddyAPI::ParameterMissingRequiredValue) { BuddyAPI::Device.register('') }
  end

  def test_register_bad_param
    TestHelper.configure_buddy
    TestHelper.check_rate_limit

    assert_raises(BuddyAPI::ParameterIncorrectFormat) do
      BuddyAPI::Device.register('Gem Test', { 'location' => '5050' })
    end
  end

  def test_update_success
    TestHelper.configure_buddy
    TestHelper.check_rate_limit(2)

    response = BuddyAPI::Device.register('Gem Test')
    token = response['result']['accessToken']

    assert BuddyAPI::Device.update(token, { 'location' => '50,50' })
  end

  def test_update_bad_token
    TestHelper.check_rate_limit

    assert_raises(BuddyAPI::AuthAccessTokenInvalid) do
     BuddyAPI::Device.update('hi', { 'location' => '50,50' })
   end
  end

  def test_update_bad_param
    TestHelper.configure_buddy
    TestHelper.check_rate_limit(2)

    response = BuddyAPI::Device.register('Gem Test')
    token = response['result']['accessToken']

    assert_raises(BuddyAPI::ParameterIncorrectFormat) do
      BuddyAPI::Device.update(token, { 'location' => '[50,50]' })
    end
  end

  def test_crash_report_success
    TestHelper.configure_buddy
    TestHelper.check_rate_limit(2)

    response = BuddyAPI::Device.register('Gem Test')
    token = response['result']['accessToken']

    assert BuddyAPI::Device.crash_report(token, 'crash report success stack trace')
  end

  def test_crash_report_bad_token
    TestHelper.check_rate_limit

    assert_raises(BuddyAPI::AuthAccessTokenInvalid) do
     BuddyAPI::Device.crash_report('hi', 'crash report failure stack trace')
   end
  end

  def test_crash_report_bad_param
    TestHelper.configure_buddy
    TestHelper.check_rate_limit(2)

    response = BuddyAPI::Device.register('Gem Test')
    token = response['result']['accessToken']

    assert_raises(BuddyAPI::ParameterIncorrectFormat) do
      BuddyAPI::Device.crash_report(token, 'stack trace', { 'location' => '[50,50]' })
    end
  end
end
