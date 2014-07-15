# Buddy API

**Note:** This Gem is currently in development and unreleased at this time. Eventually, the below will be true!

Currently, most of the code is in, and some calls are functional. Before I release, I want to get some more tests running however. After I have a significant portion tested, I'll release a few betas and continue finalizing different modules.

There is currently significant code reuse. I'm not sure if I'll be working on that before or after release, but it is something that will get accomplished quickly. 


----

## Installation

Add this line to your application's Gemfile:

    gem 'buddy_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install buddy_api

## Usage

TODO: Write usage instructions here

    BuddyAPI.configure do |config|
      config.app_id = 'AppID Here'
      config.app_key = 'AppKey Here'
      # Must be one of [:free, :pro, :enterprise]. Defaults to :free
      config.tier = :free
    end

## Contributing

1. Fork it ( https://github.com/[my-github-username]/buddy_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

#### Testing

To test this gem, you'll need to register a test application on Buddy. Make a new file `test/config.yml` with the following contents:

    appID: Your ID Here
    appKey: Your Key Here

After that, you should be able to run `rake test` effectively.


## Changelog

N/A
