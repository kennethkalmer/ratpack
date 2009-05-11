#!/usr/bin/env ruby
require 'rubygems'

begin
  # Attempt to load github gem first
  gem 'sinatra-sinatra'
rescue Gem::LoadError
end

require 'sinatra'

use Rack::ShowExceptions

configure do
  require 'yaml'
  config = YAML.load_file( File.dirname(__FILE__) + '/config/ratpack.yml' )

  RATPACK_ROOT = File.dirname(__FILE__) unless defined?( RATPACK_ROOT )

  require 'lib/ratpack'
  Ratpack::Application.config = config

  trap(:INT) do
    Ratpack::Application.shutdown!
  end
end

get '/' do
  '<html><head><title>Talk!</title></head><body><h1>Talk!</h1></body></html>'
end

post '/xmpp/message' do
  to = params[:to]
  message = params[:message]

  Ratpack::Application.xmpp.message( to, message ).to_xml
end

post '/xmpp/broadcast' do
  to = params['recipients[]']
  message = params[:message]

  Ratpack::Application.xmpp.broadcast( message, to ).to_xml
end

post '/xmpp/pool' do
  to = params[:pool]
  message = params[:message]

  Ratpack::Application.xmpp.pool( to, message ).to_xml
end

post '/amqp/:queue' do
  queue = params[:queue]
  message = params[:message]

  Ratpack::Application.amqp.publish( queue, message ).inspect
end

post '/smtp' do
  to = params[:to]
  subject = params[:subject]
  body = params[:body]

  Ratpack::Application.smtp.send_message( to, subject, body ).inspect
end
