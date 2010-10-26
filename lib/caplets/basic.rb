require 'caplets/version'
require 'caplets/utils'

config = Capistrano::Configuration.instance(:raise_on_error)

# Apparently $: isn't good enough for Capistrano.
config.instance_eval do
  @load_paths.unshift File.expand_path('..',File.dirname(__FILE__))
end

config.load 'caplets/deploy'
config.load 'caplets/ssh'
