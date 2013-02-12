require 'rubygems' unless Object.const_defined?(:Gem)

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'fileutils'
require 'net/http'

require 'jar_wrapper/runner'

require 'rbconfig'

def windows?
  !!(RbConfig::CONFIG['host_os'] =~ /mswin|mingw|windows/)
end

windows? ? (require "zip/zipfilesystem") : (require 'zip/zip')

