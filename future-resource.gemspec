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

  s.add_development_dependency 'bundler', [">= 1.0.0"]
  s.add_development_dependency 'rspec', [">= 2.5.0"]
  s.add_development_dependency 'ci_reporter', [">= 1.6.3"]
  s.add_development_dependency 'yard', [">= 0.7.0"]
  s.add_development_dependency 'rake', [">= 0"]
  s.add_development_dependency 'guard-rspec'
end
