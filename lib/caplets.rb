require 'caplets/basic'

config = Capistrano::Configuration.instance(:raise_on_error)
config.load 'caplets/bundle'
config.load 'caplets/db'
config.load 'caplets/logs'
config.load 'caplets/web'
config.load 'caplets/yaml'
