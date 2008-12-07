module Ratpack

  # Manage a pool of Jabber ID's
  class Pool

    # Our strategy
    attr_reader :strategy

    # Members of the pool
    attr_reader :members

    def initialize( *members )
      @members = []
      @members.concat( members )

      @strategy = :random

      befriend_members!
    end

    # Set the new strategy for sending messages. Can be anyone of the deliver_*
    # methods on #Pool.
    def strategy=( new_strategy )
      raise ArgumentError, "Unknown strategy" unless self.respond_to?( "deliver_#{new_strategy}".to_sym )
    end

    # Send the message using the set strategy
    def deliver( message )
      __send__( "deliver_#{self.strategy}".to_sym, message )
    end

    # Send a message to a random member in the pool
    def deliver_random( message )
      target = @members.rand
      puts "Randomly picked from pool: #{target}"
      Application.connection.deliver( target, message )
    end

    protected

    def befriend_members!
      @members.each { |m| Application.befriend_contact!( m ) }
    end

  end
end
