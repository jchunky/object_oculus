$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require "whats_up"
include WhatsUp

RSpec.configure do |config|
  config.deprecation_stream = '/dev/null'
end
