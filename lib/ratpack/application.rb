module Ratpack
  class Application

    # XMPP instance
    @@xmpp = nil

    # AMQP instance
    @@amqp = nil
    
    class << self
      
      # Spawn the backends
      def run( config )
        @xmpp = XMPP.instance( config["xmpp"] )
      end
      
      # Close down the backends
      def shutdown!
        @xmpp.shutdown!
      end

      def xmpp
        @xmpp
      end

      def amqp
        @amqp
      end
    end
  end
end
