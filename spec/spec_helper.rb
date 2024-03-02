$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require "object_oculus"
include ObjectOculus

RSpec.configure do |config|
  config.deprecation_stream = '/dev/null'
end
