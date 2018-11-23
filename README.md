# Sometimes

Sometimes backups are good.

Too simple script (tss) to create backups or other regular tasks with file output.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sometimes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sometimes

## Dump structure

# Assume this directory structure:
# $ tree
# .
# ├── filedumps
# │   ├── daily
# │   ├── monthly
# │   └── weekly


Path Key Schedule User Host What Type Comment

### Config Files

example:

path: /tmp/exaback
key: /tmp/key
comment: exabackup files
store_size:
  daily: 3
  weekly: 2
  monthly: 2
  yearly: 1
user: back-up
host: 12.211.2.1
type: tgz
what: /var/exaback


## Usage

Multiple entries.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sometimes. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Sometimes project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sometimes/blob/master/CODE_OF_CONDUCT.md).
