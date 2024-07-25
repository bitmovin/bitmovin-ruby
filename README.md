# [![bitmovin](http://bitmovin-a.akamaihd.net/webpages/bitmovin-logo-github.png)](http://www.bitmovin.com) Bitmovin::Ruby API Client (DEPRECATED)
[![codecov](https://codecov.io/gh/bitmovin/bitmovin-ruby/branch/develop/graph/badge.svg)](https://codecov.io/gh/bitmovin/bitmovin-ruby)
[![Build Status](https://travis-ci.org/bitmovin/bitmovin-ruby.svg?branch=develop)](https://travis-ci.org/bitmovin/bitmovin-ruby)

Bitmovin::Ruby API-Client which enables you to seamlessly integrate the [Bitmovin API](https://bitmovin.com/video-infrastructure-service-bitmovin-api/) into your projects.
Using this API client requires an active account. [Sign up for a Bitmovin API key](https://bitmovin.com/bitmovins-video-api/).

The full [Bitmovin API reference](https://bitmovin.com/encoding-documentation/bitmovin-api/) can be found on our website.

## Deprecation Notice

`bitmovin-ruby` is the legacy Bitmovin API client for Ruby and is not maintained anymore.

We recommend using one of the newer clients, you can find a list of available clients in our [Bitmovin Docs](https://developer.bitmovin.com/encoding/docs/sdks). Using the new client guarantees 100% specification conformity at any given time and access to all features of the API as soon as they are released. Unfortunately, currently there is no new client available for the Ruby programming languate yet.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bitmovin-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitmovin-ruby

## Examples

Please check out our examples at [examples](https://github.com/bitmovin/bitmovin-ruby/tree/develop/examples).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bitmovin/bitmovin-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

