---
layout: default
title: Caplets by Mint Digital
---

## _Capistrano Super Powers_

Capistrano is old and busted, right? Time to move on? WRONG! Caplets makes
capistrano the new hotness once again. It brings capistrano into the future
with all your favorite goodies. Git-based deploys and a collection of
useful modules will make your deploys speedy and painless.

Caplets is 1) a replacement deployment strategy that uses git instead of
subdirectories and symlinks and 2) a series of loadable capistrano extensions
to layer on addition functionality. This gives you a solid deployment
foundation with maximum flexibility. Only the tasks you need get run.

Want to use unicorn? `load 'caplets/unicorn'` How about thinking-sphinx?
`load 'caplets/thinking-sphinx'` Bundler? Network filesystem? YAML config
files? Yes, yes, and yes.

## Quickstart

    $ gem install caplets

    # in config/deploy.rb
    require 'caplets'
    load 'caplets/memcached'
    load 'caplets/whenever'
    # etc...

## More Information

For more information, check out the complete [README][]. A complete list of
all modules, along with a description of each can be found in the
[MODULES][] file.

Having trouble or found a bug? [Issues][] are open. Be sure to check out
already open issues first. Attach a patch or [fork away][].

[README]: http://github.com/mintdigital/caplets#readme
[MODULES]: http://github.com/mintdigital/caplets/blob/master/MODULES.md
[Issues]: http://github.com/mintdigital/caplets/issues
[fork away]: http://github.com/mintdigital/caplets/fork

Copyright © 2010 Mint Digital Ltd.
Released under the terms of the [MIT License][].

[MIT License]: http://github.com/mintdigital/caplets/blob/master/MIT-LICENSE
