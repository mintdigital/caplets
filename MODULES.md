Caplets Modules
===============

## caplets/deploy

### Variables

`:bin_cmd` - Command used to execute binaries within the context of the app.
  For instance, `caplets/bundle` sets this to `gem exec`. (default: `nil`)

`:environment` - The environment for this deployment, used as RAILS_ENV among
  other things. (default: `production`)

`:required_children` - Directories that need to exist in the project root.
  These will be created during `deploy:setup`. This is the caplets replacement
  of `:shared_children`. (default: `%w[config log public tmp/pids]`)

`:server_processes` - Number of backend processes (ie, mongrels or unicorn
  workers) to run. (default: `2`)

`:server_port` - Port number on which to bind backend processes.
  (default: `8000`)

`:user` - UNIX user as which to login and run deploys. (default: `deploy`)

## caplets/bundle

Bundler 0.9+ support. By default, run after every code update, this `bundle
install`s gems into the project (not into system gems to avoid using `sudo`).

### Variables

`:bundle_exclude` - Bundler groups to exclude from installation. Passed to
  bundler's `--without` switch. (default: `%w[development test]`)

`:bundle_roles` - The server roles on which to bundle. (default: `[:app]`)

`:bundle_to` - Subdirectory of the application in which to put installed gems.
  Passed as an argument to `bundle install`. (default: `vendor/bundled_gems`)

### Tasks

`deploy:bundle:install` - Runs a `bundle install` to install needed gems from
  the application's Gemfile.

### Hooks

`deploy:bundle:install` after `deploy:update_code`

## caplets/db

Tasks to support using ActiveRecord within your applications. This module
adds functionality to write out your `database.yml` file and provides a
`deploy:migrations` task.

Differently from capistrano defaults, caplets does not expect your code to be
deployed to your DB server. This means you don't even have to list it in your
deploy file. Instead, it expects to run your migrations from your `:primary
:app` server.

### Variables

`:db_host` - default: `localhost`
`:db_adapter` - default: `mysql`
`:db_database` - default: `<application>_<environment>`
`:db_username` - default: `<user>`
`:db_password` - default: `<prompt for value>`
`:db_encoding` - default: `utf8'

These variables are used to set the corresponding values in your
`database.yml` file. These values will be scoped appropriately under a key
for your current `:environment`. If you'd rather, you can specify the entire
`database.yml` yourself using `:db_confg`

`:db_extra` - A hash of values merged into your :db_config, outside of any
  environment key. Useful for adding access to slaves or other DBs.
  (default: {})

### Tasks

`deploy:db:config` - Write a generated `database.yml` to your project's config
  directory.

`deploy:migrate` - Run `rake db:migrate` on your primary app server.

`deploy:migrations` - Do a deploy with migrations, including doing a
  `web:disable` first and restarting (not reloading) the backends

### Hooks

`deploy:db:config` after `deploy:setup`

## caplets/git-tag

Automatically tag a revision on deploy.

### Tasks

`git:tag_current_release` - Tag the `:current_revision` with a tag like
`deploy-<environment>-<timestamp>` and push it to the origin.

### Hooks

`git:tag_current_release` after `deploy:migrations`
`git:tag_current_release` after `deploy:quick`
`git:tag_current_release` after `deploy:rebuild`

## caplets/memcached

Support for keeping track of memcached nodes and writing a `memcached.yml`
config file based on the `:memcached` role.

### Variables

`:memcached_servers` - An array of 'host:port' strings of memcached servers.
If any of your servers have the `:memcached` role, this is constructed
dynamically based on those servers' `:private_ip`s. Otherwise:
(default: `%w[localhost:11211]`)

### Tasks

`deploy:memcached:config` - Write a generated `memcached.yml` to your
  project's config directory.

### Hooks

`deploy:memcached:config` after `deploy:setup`

## caplets/mongrel

## caplets/networkfs

## caplets/passenger

## caplets/thinking-sphinx

## caplets/unicorn

## caplets/unicorn_rails

## caplets/utils

## caplets/web

## caplets/whenever

## caplets/yaml
