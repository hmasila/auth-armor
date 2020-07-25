# Auth::Armor

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/auth/armor`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'auth-armor'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install auth-armor

## Usage

The library needs to be instantiated with your client_id and client_secret. This returns a client object that is authenticated with Oauth2.

```ruby
require "auth-armor"
AuthArmor::Client.new(client_id: "CLIENT_ID", client_secret: "CLIENT_SECRET")

```


## Auth Request

To send an Auth request to the a mobile device or security key, call the `auth_request` method with the following arguments

```ruby
AuthArmor::Client.auth_request(
  auth_profile_id: "AUTH_PROFILE_ID",
  action_name: "Login",
  short_msg: "This is a test message",
)
```

### Auth Request for Mobile Device

```ruby
AuthArmor::Client.auth_request(
  auth_profile_id: "AUTH_PROFILE_ID",
  action_name: "Login",
  short_msg: "This is a test message",
  accepted_auth_methods: "mobiledevice"
)
```

### Auth Request for Mobile Device when Biometrics are enforced

```ruby
AuthArmor::Client.auth_request(
  auth_profile_id: "AUTH_PROFILE_ID",
  action_name: "Login",
  short_msg: "This is a test message",
  accepted_auth_methods: "mobiledevice",
  forcebiometric: true
)
```

### Auth Request for Security Key

```ruby
AuthArmor::Client.auth_request(
  auth_profile_id: "AUTH_PROFILE_ID",
  action_name: "Login",
  short_msg: "This is a test message",
  accepted_auth_methods: "securitykey"
)
```

### Optional arguments

`timeout_in_seconds`, `accepted_auth_methods`, `forcebiometric`

If `forcebiometric` is false by default. It is only applicable if one of the `accepted_auth_methods` is `mobiledevice`

`accepted_auth_methods` can either be `mobiledevice` or `securitykey`. If neither is provided, both auth methods are acceptable.

`timeout_in_seconds` is the amount of time you want to allow the auth to be valid before it expires. The min is 15, and max is 300. If not provided, the default time for the project is used.



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hmasila/auth-armor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hmasila/auth-armor/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Auth::Armor project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hmasila/auth-armor/blob/master/CODE_OF_CONDUCT.md).
