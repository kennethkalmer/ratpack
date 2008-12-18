module Ratpack
end

$:.unshift File.dirname(__FILE__)

require 'ratpack/application'
require 'ratpack/pool'
require 'ratpack/response'
require 'ratpack/multipart'
require 'ratpack/request_handler'
