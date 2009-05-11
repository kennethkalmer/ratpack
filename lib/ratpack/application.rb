module Ratpack
  class Application

    # XMPP instance
    @@xmpp = nil

    # AMQP instance
    @@amqp = nil

    # SMTP instance
    @@smtp = nil

    class << self

      # Spawn the backends
      def config=( config )
        @@config = config
        
        #@@xmpp = XMPP.instance( config["xmpp"] )
        #@@amqp = AMQP.instance( config["amqp"] )
        #@@smtp = SMTP.instance( config["smtp"] )
      end

      # Close down the backends
      def shutdown!
        @@xmpp.shutdown!
        @@amqp.shutdown!
      end

      def xmpp
        @@xmpp ||= XMPP.instance( @@config['xmpp'] )
      end

      def amqp
        @@amqp ||= AMQP.instance( @@config['amqp'] )
      end

      def smtp
        @@smtp ||= SMTP.instance( @@config['smtp'] )
      end
    end
  end
end
