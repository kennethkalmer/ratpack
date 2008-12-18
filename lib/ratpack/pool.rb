module Ratpack

  # Manage a pool of Jabber ID's
  class Pool

    # Our strategy
    attr_reader :strategy

    # Members of the pool
    attr_reader :members

    def initialize( application, *members )
      @application = application

      @members = []
      @members.concat( members.to_a.compact.flatten )

      @strategy = :random

      befriend_members!
    end

    # Set the new strategy for sending messages. Can be anyone of the deliver_*
    # methods on #Pool.
    def strategy=( new_strategy )
      raise ArgumentError, "Unknown strategy" unless self.respond_to?( "deliver_#{new_strategy}".to_sym )
      @strategy = new_strategy
    end

    # Send the message using the set strategy
    def deliver( message )
      __send__( "deliver_#{self.strategy}".to_sym, message )
    end

    # Send a message to a random member in the pool
    def deliver_random( message )
      target = @members[ rand(@members.size - 1) ]
      @application.deliver( target, message )

      Response.new( message, target )
    end

    def deliver_broadcast( message )
      @members.each { |m| @application.deliver( m, message ) }

      Response.new( message, @members )
    end

    protected

    def befriend_members!
      @members.each { |m| @application.befriend_contact!( m ) }
    end

  end
end
