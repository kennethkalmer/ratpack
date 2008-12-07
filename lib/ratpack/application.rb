module Ratpack
  class Application
    
    # JabberID to use
    @@jabber_id = nil
    cattr_accessor :jabber_id

    # Jabber password
    @@password = nil
    cattr_accessor :password

    # Jabber resource
    @@resource = 'ratpack'
    cattr_accessor :resource

    # Contacts that are always included in the participants roster
    @@contacts = []
    cattr_accessor :contacts

    # Jabber connection
    @connection = nil
    attr_reader :connection

    @@instance = nil

    class << self

      def deliver( to, message )
        instance.deliver( to, message )
      end

      # Quickly befriend a contact
      def befriend_contact!( jid )
        instance.befriend_contact!( jid )
      end

      def instance( *args )
        @instance ||= new( *args )
        @instance.startup!
      end
      private :new

    end

    # Start our application
    def initialize( options = {} )
      self.class.jabber_id = options.delete(:jabber_id) if options.has_key?(:jabber_id)
      self.class.password  = options.delete(:password)  if options.has_key?(:password)
      self.class.contacts  = options.delete(:contacts)  if options.has_key?(:contacts)
      self.class.resource  = options.delete(:resource)  if options.has_key?(:resource)

      @message_queue = Queue.new
    end

    # Send a message to a specific Jabber ID
    def message( to, message )
      self.deliver( to, message )

      Response.new( message, to )
    end

    # Broadcast a message to all Jabber ID's
    def broadcast( message, recipients )
      temp_pool = Pool.new( self, recipients )
      temp_pool.strategy = :broadcast
      temp_pool.deliver( message )
    end

    # Broadcast a message to a single Jabber ID in the pool
    def pool( to, message )
      target_pool = @pools[to]
      unless target_pool.nil?
        target_pool.deliver( message )
      else
        not_found do
          Response.new( message, [], 'Pool not found')
        end
      end
    end

    # Threaded delivery
    def deliver( to, message )
      self.connection.deliver( to, message )
      #@message_queue.push( [to, message] )
    end

    # Quickly befriend a contact
    def befriend_contact!( jid )
      self.connection.add( jid )
      self.connection.roster.accept_subscription( jid )
    end

    def startup!
      return self if @booted
      
      connect!
      setup_roster!
      setup_pools!
      setup_delivery_thread!
      
      @booted = true
      
      self
    end

    def shutdown!
      self.connection.disconnect
#      @delivery_thread.exit
    end

    private

    def connect!
      jid = self.class.jabber_id + '/' + self.class.resource

      @connection = Jabber::Simple.new( jid, self.class.password, nil, "Ratpack waiting for instructions" )

      self.connection.reconnect unless self.connection.connected?
    end

    # Clear all contacts from the roster, and build up the roster again
    def setup_roster!
      # Clean the roster
      self.connection.roster.items.each_pair do |jid, roster_item|
        jid = jid.strip.to_s
        unless self.class.contacts.include?( jid )
          self.connection.remove( jid )
        end
      end

      # Add missing contacts
      self.class.contacts.each do |contact|
        unless self.connection.subscribed_to?( contact )
          self.befriend_contact!( contact )
        end
      end
    end

    def setup_pools!
      if File.exists?( RATPACK_ROOT + '/config/pools.yml' )
        groups = YAML::load_file( RATPACK_ROOT + '/config/pools.yml' )

        @pools = groups.inject({}) do |memo, group|
          memo[ group.shift ] = Pool.new( self, *group.shift )
          memo
        end
      else
        @pools = {}
      end
    end

    def setup_delivery_thread!
#      @delivery_thread = Thread.new do
#        while message = @message_queue.pop
#          self.connection.resconnect unless self.connection.connected?
#          self.connection.deliver( *message )
#        end
#      end
#      @delivery_thread.abort_on_exception = true
    end
  end
end