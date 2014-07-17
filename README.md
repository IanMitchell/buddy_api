# Buddy API

**Note:** _This Gem is currently in development and unreleased at this time._

Most of the Buddy API codebase is in, it just hasn't been tested yet. There also is currently significant code reuse. Both problems are being worked on over time!


### Fully Tested and Documented

1. Core (used internally)
2. Device
3. User

### Tested and Undocumented

1. N/A

### Untested and Undocumented

1. Album
2. Album Item
3. Blob
4. Checkin
5. Game
6. Identity
7. Location
8. Message
9. Metadata
10. Metric
11. Picture
12. Player
13. Push
14. Score
15. Scoreboard
16. Session
17. User List
18. Video

----

## Installation

_Since this gem is currently unreleased, the below is not true._

Add this line to your application's Gemfile:

    gem 'buddy_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install buddy_api

## Configuraton

Before you can make calls, you must configure the gem as such:

    BuddyAPI.configure do |config|
      config.app_id = 'AppID Here'
      config.app_key = 'AppKey Here'
      # Must be one of [:free, :pro, :enterprise]. Defaults to :free
      config.tier = :free
    end

#### Testing

To test this gem, you'll need to register a test application on Buddy. Make a new file `test/config.yml` with the following contents:

    appID: Your ID Here
    appKey: Your Key Here

After that, you should be able to run `rake test` effectively.


## Changelog

N/A
