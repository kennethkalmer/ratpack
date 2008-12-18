RATPACK_BASE = File.dirname(__FILE__) + '/..' unless defined?( RATPACK_BASE )

unless RUBY_VERSION >= "1.9.1"
  puts "Ratpack is designed to run on Ruby 1.9.1 and won't run on Ruby #{RUBY_VERSION}"
  exit 1
end

require 'rubygems'
require 'yaml'

require 'eventmachine'
require 'evma_httpserver'
gem 'espace-neverblock'
require 'neverblock'

$:.unshift RATPACK_BASE + '/vendor/kennethkalmer-xmpp4r-simple/lib'
require 'xmpp4r-simple'

require RATPACK_BASE + '/lib/ratpack'
