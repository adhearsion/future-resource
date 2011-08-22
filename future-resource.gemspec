# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "future-resource/version"

Gem::Specification.new do |s|
  s.name        = "future-resource"
  s.version     = FutureResource::VERSION
  s.authors     = ["Jay Phillips", "Ben Langfeld"]
  s.email       = ["dev@adhearsion.com"]
  s.homepage    = "https://github.com/adhearsion/future-resource"
  s.summary     = %q{Wait on resources being set in the future}
  s.description = %q{Sometimes a value is set asynchronously and you need to wait until it appears. Easy!}

  s.rubyforge_project = "future-resource"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency %q<rspec>, ["~> 2.3.0"]
  s.add_development_dependency %q<yard>, ["~> 0.6.0"]
end
