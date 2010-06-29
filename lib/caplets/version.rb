module Caplets
  module Version
    MAJOR = 1
    MINOR = 0
    TINY  = 1
    BUILD = 'pre'
    STRING = [MAJOR,MINOR,TINY,BUILD].compact.join('.')
  end
  VERSION = Version::STRING
end
