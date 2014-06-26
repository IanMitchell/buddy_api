require 'test/unit'
require 'test_helper'
require 'buddy_api'

class BuddyTest < Test::Unit::TestCase
  def test_valid_configuration
    BuddyAPI::reset
    assert !BuddyAPI::valid_configuration?

    TestHelper::configure_buddy
    assert BuddyAPI::valid_configuration?
  end

  def test_valid_request_counter
    TestHelper::configure_buddy
    response = BuddyAPI::Device::register('Gem Test')

    assert_equal 1, BuddyAPI::call_count

    sleep(1.5)
    assert_equal 0, BuddyAPI::call_count
  end

  def test_request_url
    assert_equal BuddyAPI::ROOT_URL, BuddyAPI::request_url

    BuddyAPI::set_request_url('https://api-2.buddyplatform.com')
    assert_equal 'https://api-2.buddyplatform.com', BuddyAPI::request_url

    # Reset for future tests
    BuddyAPI::set_request_url BuddyAPI::ROOT_URL
  end
end
