# PassengerStatusCheck

Provides a basic command-line tool to parse the output of the passenger-status
utility, when generated as XML.  This is a jumping-off point, not a comprehensive
solution.  Currently generates output in check_mk format (for Nagios), but can
be easily extended for StatsD/Graphite, Elasticsearch, etc.

It is designed to read data from a stream/pipe, so if you're reading from a file,
`cat` the output and pipe it in.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'passenger_status_check'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install passenger_status_check

Alternatively, [GNU Guix](https://gnu.org/software/guix) users may
install the development snapshot described in `package.scm`:

    $ guix package --install-from-file=package.scm


## Usage

After install, you can run passenger_status_check --help to see available options.
To test it out, use the fixture in the spec file, like so:

`cat spec/fixtures/pass-status.xml | passenger_status_check`

This will generate check_mk-style output.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

[GNU Guix](https://gnu.org/software/guix) users can create a
development environment by running `guix environment -l package.scm`.
This will spawn a shell in which all dependencies are available.  The
environment has been tested with Guix 0.8.4.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vhl/passenger_status_check.

## License

GNU General Public License version 3 or later

See `COPYING` for the full license text.
