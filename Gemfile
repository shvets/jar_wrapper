source :rubygems

require 'rbconfig'

def windows?
  !!(Config::CONFIG['host_os'] =~ /mswin|mingw|windows/)
end

gem 'jeweler'
gem "zip"
gem "rubyzip" if windows?

group :development do
  gem "gemspec_deps_gen"
  gem "gemcutter"
end

group :test do
  gem "rspec"
  gem "mocha"
end



