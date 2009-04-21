module Ratpack
end

$:.unshift File.dirname(__FILE__)

require 'activesupport'
require 'xmpp4r-simple'

require 'ratpack/application'
require 'ratpack/xmpp'
require 'ratpack/amqp'
require 'ratpack/pool'
require 'ratpack/response'
