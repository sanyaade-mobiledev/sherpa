# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sherpa/version"

Gem::Specification.new do |s|
  s.name        = "sherpa"
  s.version     = Sherpa::VERSION
  s.authors     = ["Matt Kitt"]
  s.email       = ["info@modeset.com"]
  s.homepage    = ""
  s.summary     = %q{A code documentation tool with support for generating styleguides}
  s.description = %q{A code documentation tool with support for generating styleguides}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "redcarpet", "~> 2.1.1"
  s.add_runtime_dependency 'mustache',  '~> 0.99.4'

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
