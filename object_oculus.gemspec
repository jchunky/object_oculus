# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "object_oculus/version"

Gem::Specification.new do |s|
  s.name        = "object_oculus"
  s.version     = ObjectOculus::VERSION
  s.authors     = ["Jason Cheong-Kee-You", "Bryan McKelvey", "Dr Nic Williams"]
  s.email       = ["j.chunky@gmail.com", "bryan.mckelvey@gmail.com", "drnicwilliams@gmail.com"]
  s.homepage    = "https://github.com/jchunky/object_oculus"
  s.summary     = %q{Determine what methods can be called on an object that return a given value}
  s.description = %q{Determine what methods can be called on an object that return a given value}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler"
  s.add_development_dependency "rspec"
end

