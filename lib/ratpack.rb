require 'activesupport'
require 'xmpp4r-simple'
require 'amqp'
require 'mq'

$:.unshift File.dirname(__FILE__)

require 'ratpack/application'
require 'ratpack/xmpp'
require 'ratpack/amqp'
require 'ratpack/pool'
require 'ratpack/response'

module Ratpack
end
