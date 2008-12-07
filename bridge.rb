#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'

use Rack::ShowExceptions

RATPACK_ROOT = File.dirname(__FILE__) unless defined?( RATPACK_ROOT )
require 'lib/ratpack'
ratpack = Ratpack::Application.new( 
  :jabber_id => 'ratpack@devbox',
  :password => 'secret',
  :contacts => ['kenneth@devbox']
)

get '/' do
  '<html><head><title>Talk!</title></head><body><h1>Talk!</h1></body></html>'
end

post '/message' do
  to = params[:to]
  message = params[:message]

  ratpack.message( to, message ).to_xml
end

post '/broadcast' do
  to = params['recipients[]']
  message = params[:message]

  ratpack.broadcast( message, to ).to_xml
end

post '/pool' do
  to = params[:pool]
  message = params[:message]

  ratpack.pool( to, message ).to_xml
end
