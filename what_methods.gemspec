# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "what_methods/version"

Gem::Specification.new do |s|
  s.name        = "what_methods"
  s.version     = WhatMethods::VERSION
  s.authors     = ["Dr Nic Williams"]
  s.email       = ["drnicwilliams@gmail.com"]
  s.homepage    = "http://drnicutilities.rubyforge.org"
  s.summary     = %q{Determine what methods can be called on an object that return a given value}
  s.description = %q{Determine what methods can be called on an object that return a given value}

  s.rubyforge_project = "drnicutilities"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
