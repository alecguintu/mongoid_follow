# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongoid_follow/version"

Gem::Specification.new do |s|
  s.name        = "mongoid_follow"
  s.version     = MongoidFollow::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alec Guintu"]
  s.email       = ["animerei12@gmail.com"]
  s.homepage    = "https://github.com/alecguintu/mongoid_follow"
  s.summary     = %q{ Add basic "follow" features to rails3 + mongoid }
  s.description = %q{ Gem to add basic "follow" features if you're using rails3 with mongoid }

  s.rubyforge_project = "mongoid_follow"

  s.add_dependency "mongoid"
  s.add_dependency "bson_ext"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
