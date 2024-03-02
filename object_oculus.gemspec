$LOAD_PATH.push File.expand_path("lib", __dir__)
require "object_oculus/version"

Gem::Specification.new do |s|
  s.name = "object_oculus"
  s.authors = ["Jason Cheong-Kee-You", "Bryan McKelvey", "Dr Nic Williams"]
  s.email = "j.chunky@gmail.com"
  s.homepage = "https://github.com/jchunky/object_oculus"
  s.licenses = ["MIT"]
  s.metadata["rubygems_mfa_required"] = "true"
  s.platform = Gem::Platform::RUBY
  s.version = ObjectOculus::VERSION
  s.summary = "Rapidly explore an object's API in 'irb'"
  s.description = <<~DESCRIPTION
    ObjectOculus is a ruby tool for viewing all of an object's methods and seeing what those
    methods return. ObjectOculus can be used in 'irb' to rapidly explore an object's API.
  DESCRIPTION

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]


  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rubocop", "~> 1.0"
end
