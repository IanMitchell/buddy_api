require 'test/unit'
require 'test_helper'
require 'buddy_api'

class BuddyTest < Test::Unit::TestCase
  def test_valid_configuration
    BuddyAPI.reset
    assert !BuddyAPI.valid_configuration?

    TestHelper.configure_buddy
    assert BuddyAPI.valid_configuration?
  end

  def test_request_url
    assert_equal BuddyAPI::ROOT_URL, BuddyAPI.request_url

    BuddyAPI.set_request_url('https://api-2.buddyplatform.com')
    assert_equal 'https://api-2.buddyplatform.com', BuddyAPI.request_url

    # Reset for future tests
    BuddyAPI.set_request_url BuddyAPI::ROOT_URL
  end

  def test_valid_request_counter
    TestHelper.configure_buddy
    sleep(1)

    BuddyAPI.increment_call_count
    assert_equal 1, BuddyAPI.call_count

    sleep(1)
    assert_equal 0, BuddyAPI.call_count
  end

  def test_valid_rate_capped
    TestHelper.configure_buddy
    sleep(1)

    BuddyAPI::FREE_TIER_CAP.times do |i|
      assert !BuddyAPI.rate_capped?
      BuddyAPI.increment_call_count
      assert_equal BuddyAPI.requests_left, BuddyAPI::FREE_TIER_CAP - (i + 1)
    end

    assert BuddyAPI.rate_capped?


    sleep(1)
    BuddyAPI.configure { |config| config.tier = :enterprise }

    BuddyAPI::ENTERPRISE_TIER_CAP.times do |i|
      assert !BuddyAPI.rate_capped?
      BuddyAPI.increment_call_count
      assert_equal BuddyAPI.requests_left, BuddyAPI::ENTERPRISE_TIER_CAP - (i + 1)
    end

    assert BuddyAPI.rate_capped?
  end
end
