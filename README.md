# Sometimes

Sometimes backups are good.

Too simple script (tss) to create backups or other regular tasks with file output via ssh.

Only ready to use for the insanest of all people.

Copyright 2018 Felix Wolfsteller, licensed under the GPLv3 (see LICENSE file for details).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sometimes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sometimes

## General

`sometimes` can be used like the following:

Two servers exists (called `productive` and `backup`).  A copy of certail files on the `productive` server should be made every day (to the `backup` server).  A certain number of these copies should be kept (e.g. copies of the last /three/ days, of the last /two weeks/ and one from the beginning of the year).

The connection shall be made from the `backup` server to the `productive` server.  This is done via restricted ssh connections.

A cronjob on the `backup` server will run daily and connect via ssh (password-less key) to the `productive` server.  Via an entry in the `authorized_keys` file of the relevant user on the `productive` server it is ensured that just a gzipped tarball is sent over the ssh-connection (and no other stuff can be executed, no tunnels can be created, ...).

The `backup` server than saves whatever comes out of the ssh-connection to a file with a timestamp as a name.

According to the given storage schedule (e.g. keep last three days copies), outdated old copies are deleted.

While all this behavior can be achieved with cron, rsync, shell-scripts, logrotate and co. this ruby gem tries to abstract some of that functionality (e.g. `ssh` is called internally) or re-implement it in a worse way (e.g. logrotate works, the storage scheduling in this gem is pretty fake).


## Dump structure

```
# Assume this directory structure:
# $ tree
# .
# ├── filedumps
# │   ├── daily
# │   │   ├── 2018-01-04_2000.tgz
# │   │   └── 2018-01-05_2000.tgz
# │   ├── weekly
# │   │   └── 2018-01-02_2000.tgz
# │   ├── monthly
# │   │   └── 2018-01-01_2000.tgz
# │   ├── yearly
# │   │   ├── 2017-01-01_2000.tgz
# │   │   └── 2018-01-01_2000.tgz
# │   └── last
```


### Config Files

A config file (for the moment called `BackupDefinition`) explains what should be backupped where and how.

example:

```
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
```

## Usage

  - Set up a dedicated user on the `productive` server and its permissions.
  - On the backup server, create a configuration file that defines what when where you want to back up.
  - On the backup server, create a directory where the backups should be put.
  - On the backup server, run `sometimes-setup-keys -c <path_to_config_file>`, which will result in three files:
    * A private key (for password-less connection to productive server)
    * A public key  (for password-less connection to productive server)
    * A file with an examplary authorized_keys file line (for the productive server, for restricted and password-less connection)
  - On the backup server, run `sometimes-info -c <path_to_config_file>` to prove that you are willing to be forced into a weird workflow and off naming but also to create the relevant directories.
  - On the productive server, adjust the ~/.ssh/authorized_keys accordingly
  - On the backup server, install a cronjob, e.g. `0 1 * * * sometimes-execute -c <path_to_config_file>

Multiple entries.

Currently following scenarios (types) are supported:
  * `tgz` (simple filedump)
  * `mysql` (plain text file)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ecovillage/sometimes. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Sometimes project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ecovillage/sometimes/blob/master/CODE_OF_CONDUCT.md).
