# Jumpstarter::Api

[Jumpstarter](http://jumpstarter.io) is the AppStore for the web.

This is the basic implementation of their current 'magic sing-in button' in Ruby.

Please note, that Ruby isn't supported yet by Jumpstarter, so apps written in Ruby will be rejected currently.
It's intended as a little push in the direction of supporting Ruby natively. If so, this project might help.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jumpstarter-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jumpstarter-api

## Usage

Please make sure, that you changed the important values in `spec/fixtures/env.json`.
For proper testing you also need to follow [this guideline](https://github.com/jumpstarter-io/help/wiki/Testing-Portal-Auth-Implementations), copy & paste the token to `spec/jumpstarter_api_spec.rb`

```ruby
require 'jumpstarter/api'

js_env = Jumpstarter::Api::JumpstarterEnv.new       # In production /app/env.json is consumed
js_env = Jumpstarter::Api::JumpstarterEnv.new(json) # Pass in json for testing purposes (see: spec/fixtures/env.json)

# If token validates, sign-in the user - yep, it's that easy!
token = params['jumpstarter-auth-token']

if js_env.validate_session(token)
  # ... authenticated
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/jumpstarter-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
