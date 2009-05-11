require 'activesupport'
require 'xmpp4r-simple'
require 'amqp'
require 'mq'

$:.unshift File.dirname(__FILE__)

#require 'ratpack/application'
#require 'ratpack/xmpp'
#require 'ratpack/amqp'
#require 'ratpack/pool'
#require 'ratpack/response'
#require 'ratpack/smtp'

module Ratpack
  autoload :Application, 'ratpack/application'
  autoload :XMPP,        'ratpack/xmpp'
  autoload :AMQP,        'ratpack/amqp'
  autoload :Pool,        'ratpack/pool'
  autoload :Response,    'ratpack/response'
  autoload :SMTP,        'ratpack/smtp'
end
