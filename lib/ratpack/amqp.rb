module Ratpack
  class AMQP
    
    # Thread for EM.run requirement of amqp
    @em_thread = nil
    attr_reader :em_thread
    
    # AMQP connection
    @connection = nil
    
    # Keep it singleton
    @@instance = nil

    class << self

      def publish( queue, message )
        q = ::MQ.queue( queue )
        q.publish( message )
      end
      
      def instance( *args )
        @instance ||= new( *args )
        @instance.startup!
        @instance
      end
      
    end

    def initialize( options = {} )
      @host = options['host']

      @em_thread = Thread.new { EM.run }
    end

    def publish( queue, message )
      self.class.publish( queue, message )
    end

    def startup!
      return self if @booted
      
      @connection = ::AMQP.connect
      
      @booted = true
      
      self
    end

    def shutdown!
      EM.stop_event_loop
      @em_thread.join # give time for the event loop to stop gracefully
    end
  end
end
