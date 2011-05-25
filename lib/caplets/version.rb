module Caplets
  module Version
    MAJOR = 1
    MINOR = 0
    TINY  = 3
    BUILD = nil
    STRING = [MAJOR,MINOR,TINY,BUILD].compact.join('.')
  end
  VERSION = Version::STRING
end
