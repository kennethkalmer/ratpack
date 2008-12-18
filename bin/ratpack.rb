#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../config/boot'

Ratpack::Application.instance(
  :jabber_id => 'ratpack@devbox',
  :password => 'secret',
  :contacts => ['kenneth@devbox']
)
trap(:INT) do
  Ratpack::Application.instance.shutdown!
  EM.stop
end

EM.run {
  EventMachine.epoll
  EventMachine.start_server("0.0.0.0", "8080", Ratpack::RequestHandler)
}