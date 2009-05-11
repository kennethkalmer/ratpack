require 'net/smtp'

module Ratpack
  class SMTP

    # Keep it singleton
    @@instance = nil

    class << self

      def instance( *args )
        @instance ||= new( *args )
        @instance
      end
      
    end

    def initialize( options = {} )
      @host = options['host']
      @port = options['port']
      @from = options['from']
    end

    def send_message( recipient, subject, body )

      msg = <<EOM
From: <#{@from}>
To: <#{recipient}>
Subject: #{subject}
Date: #{Time.now.to_s}
X-Generated-By: ratpack - http://github.com/kennethkalmer/ratpack

#{body}
EOM

      Net::SMTP.start( @host, @port ) do |smtp|
        smtp.send_message( msg, @from, recipient )
      end
    end
  end
end
