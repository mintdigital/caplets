# -*- encoding: utf-8 -*-
$: << File.expand_path('lib', File.dirname(__FILE__))
require 'caplets/version'

Gem::Specification.new do |s|
  s.version = Caplets::Version::STRING

  s.name = 'caplets'
  s.summary = 'Capistrano super powers'
  s.description = <<-DESC.squeeze(' ')
    Caplets modernizes your capistrano deployments. At its most basic, it
    provides a fast, efficient git-based deployment without copying release
    trees or symlink tomfoolery. In addition, it includes modules for common
    tasks such as writing config files and crontabs, working with bundler,
    and using a networked filesystem.
  DESC
  s.authors = ["Dean Strelau"]
  s.email = 'dean@mintdigital.com'
  s.homepage = 'http://mintdigital.github.com/caplets'
  s.files = Dir["lib/**/*.rb"] +
    %w[CHANGELOG MIT-LICENSE README.md MODULES.md]
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'capistrano', '>= 2.5.0'
end
