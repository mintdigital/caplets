Caplets
=======

Capistrano is old and busted, right? Time to move on? WRONG! Caplets makes
capistrano the new hotness once again. It bring capistrano into the future
with all your favorite goodies: git, bundler, unicorn, and more.


WARNING: Caplets has evolved out of Mint Digital's real-world deployments of
many large Rails/Rack applications. Although we have tried to keep it as
generic and customizable as possible, it is still very opinionated. That is
to say, it is largely tailored to how we like to deploy applications. If
caplets is missing something important to you, [submit an issue][issues] or
[fork away][fork].

[issues]: http://github.com/mintdigital/caplets/issues
[fork]:   http://github.com/mintdigital/caplets/fork

Quickstart
----------


    $ gem install caplets

    # config/deploy.rb
    require 'caplets'
    load 'caplets/memcached'
    load 'caplets/whenever'
    # etc...

Roles
-----

Caplets depends heavily on capistrano's concept of server roles to apply tasks
only to the servers that require them. Most often, your sever definitions will
look like this:

    server 'app1.mintdigital.com',
      :app, :memcached, :sphinx, :assets,
      :primary => true

Modules
-------

Caplets is a series of `load`able capistrano extensions. This given you
maximum flexibility in your deployments without having to remember to
set/unset loads of capistrano variables. Only the tasks you need get run.

See the [MODULES][] file for descriptions of all the available modules, along
with what tasks they add and what variables they use.

[MODULES]: http://github.com/mintdigital/caplets/blob/master/MODULES.md

caplets/deploy
--------------

The one module you will _always_ get, even if you just require
`caplets/basic` is `caplets/deploy`. This file is the heart of caplets; it
sets up the essentials of what caplets considers a modern deployment.

The biggest change to the standard capistrano setup is that we use git to
manage releases. Let me say that again as it's important:

** Instead of using subdirectories and symlinks to manage releases, caplets
uses git.**

That means:

  - You will not have `releases` or `shared` directories.
  - Your code will be directly inside your `:deploy_to` directory.
  - `:current_path`, `:current_release`, `:release_path`, `:latest_release`,
    and `:shared_path` will all be the same.
  - Rollbacks still work, through the power of `git reset`
  - "shared" files are really just files written to your project root but not
    under git version control -- no symlinks needed.

Here are a few other changes that `caplets/deploy` makes:

  - `:use_sudo` is false by default
  - `:rails_env` is replaced with `:environment`, which caplets expects you to
    set in your deploy file.
  - `:user` and `:group` default to `deploy`
  - `:shared_children` is not used. Use `:required_children` instead.
  - The standard `deploy` task is disabled. Use `deploy:quick` to do an
    `deploy:update` + `deploy:reload`. Load `caplets/db` for caplets'
    replacement `deploy:migrations` task.
  - Capistrano's built-in `deploy:web:enable` and `deploy:web:disable` are
    disabled. Load `caplets/web` for caplets' replacements.

require 'caplets'
-----------------

Requiring `caplets` gets you the most common modules in one go. If you don't
want them all, you can always require `caplets/basic` instead.

    # config/deploy.rb
    require 'caplets'

    # Equivalent to...
    require 'caplets/basic'
    load 'caplets/bundle'
    load 'caplets/db'
    load 'caplets/logs'
    load 'caplets/web'
    load 'caplets/yaml'
