# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "whats_up/version"

Gem::Specification.new do |s|
  s.name        = "whats_up"
  s.version     = WhatsUp::VERSION
  s.authors     = ["Bryan McKelvey", "Dr Nic Williams"]
  s.email       = ["bryan.mckelvey@gmail.com", "drnicwilliams@gmail.com"]
  s.homepage    = "http://drnicutilities.rubyforge.org"
  s.summary     = %q{Determine what methods can be called on an object that return a given value}
  s.description = %q{Determine what methods can be called on an object that return a given value}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
