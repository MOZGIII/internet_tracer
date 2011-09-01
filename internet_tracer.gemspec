# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "internet_tracer/version"

Gem::Specification.new do |s|
  s.name        = "internet_tracer"
  s.version     = InternetTracer::VERSION
  s.authors     = ["MOZGIII"]
  s.email       = ["mike-n@narod.ru"]
  s.homepage    = "http://github.com/MOZGIII/internet_tracer"
  s.summary     = %q{Get notification when your internet is back!}
  s.description = %q{Notifies you when your DD-WRT router resores the internet connection.}

  s.rubyforge_project = "internet_tracer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
