module Ratpack
  class RequestHandler < EventMachine::Connection
    include EventMachine::HttpServer
    include Multipart

    def process_http_request
      resp = EventMachine::DelegatedHttpResponse.new( self )

      operation = proc do
        resp.status, resp.content = process!
      end

      callback = proc do |res|
        resp.send_response
      end

      EM.defer( operation, callback )
    end

    def process!
      puts "Processing #{ENV['REQUEST_URI']}"
      begin
        if ENV['REQUEST_URI'] == '/message'
          send_message
        elsif ENV['REQUEST_URI'] == '/broadcast'
          send_broadcast
        elsif ENV['REQUEST_URI'] == '/pool'
          send_pool
        else
          [404, "No clue"]
        end
      rescue => e
        [ 500, e.message + "\n\n" + e.backtrace.join("\n") ]
      end
    end

    def send_message
      to = params["to"]
      message = params["message"]

      return 200, Ratpack::Application.instance.message( to, message ).to_xml
    end

    def send_broadcast
      to = params['recipients[]']
      message = params['message']

      return 200, Ratpack::Application.instance.broadcast( message, to ).to_xml
    end

    def send_pool
      to = params['pool']
      message = params['message']

      return 200, Ratpack::Application.instance.pool( to, message ).to_xml
    end

    def params
      @params ||= parse_multipart( ENV, StringIO.new( @http_post_content ) )
    end
  end
end