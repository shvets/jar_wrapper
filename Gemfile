source "https://rubygems.org"

require 'rbconfig'

def windows?
  !!(RbConfig::CONFIG['host_os'] =~ /mswin|mingw|windows/)
end

group :default do
  gem "zip"
  gem "rubyzip" if windows?
end

group :development do
  gem "gemspec_deps_gen"
  gem "gemcutter"
end

group :test do
  gem "rspec"
  gem "mocha"
end



