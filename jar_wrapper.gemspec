# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/lib/jar_wrapper/version')

Gem::Specification.new do |spec|
  spec.name = "jar_wrapper"
  spec.summary = %q{Jar wrapper for executable java jar.}
  spec.description = %q{Jar wrapper for executable java jar.}
  spec.email = "alexander.shvets@gmail.com"
  spec.authors = ["Alexander Shvets"]
  spec.homepage = "http://github.com/shvets/jar_wrapper"

  spec.files = `git ls-files`.split($\)
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.version = JarWrapper::VERSION

  spec.add_runtime_dependency "zip", [">= 0"]
  spec.add_development_dependency "gemspec_deps_gen", [">= 0"]
  spec.add_development_dependency "gemcutter", [">= 0"]
  
end
