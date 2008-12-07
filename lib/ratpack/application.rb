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
    @@connection = nil
    cattr_reader :connection

    class << self
      
      # Quickly befriend a contact
      def befriend_contact!( jid )
        self.connection.add( jid )
        self.connection.roster.accept_subscription( jid )
      end
      
    end

    # Start our application
    def initialize( options = {} )
      self.class.jabber_id = options.delete(:jabber_id) if options.has_key?(:jabber_id)
      self.class.password  = options.delete(:password)  if options.has_key?(:password)
      self.class.contacts  = options.delete(:contacts)  if options.has_key?(:contacts)
      self.class.resource  = options.delete(:resource)  if options.has_key?(:resource)

      connect!
      setup_roster!
      setup_pools!
    end

    # Send a message to a specific Jabber ID
    def message( to, message )
      self.class.connection.deliver( to, message )
    end

    # Broadcast a message to all Jabber ID's
    def broadcast( message, *recipients )
      recipients.each do |r|
        self.connection.deliver( r, message )
      end
    end

    # Broadcast a message to a single Jabber ID in the pool
    def pool( to, message )
      target_pool = @pools[to]
      unless target_pool.nil?
        target_pool.deliver( message )
      else
        puts 'No matching pool'
      end
    end

    protected

    def connect!
      jid = self.class.jabber_id + '/' + self.class.resource
      @@connection = Jabber::Simple.new( jid, self.class.password )
      @@connection.status( :chat, "Ratpack waiting for instructions" )

      at_exit do
        @@connection.disconnect if @@connection
        @@connection = nil
      end
    end

    # Clear all contacts from the roster, and build up the roster again
    def setup_roster!
      # Clean the roster
      self.class.connection.roster.items.each_pair do |jid, roster_item|
        jid = jid.strip.to_s
        unless self.class.contacts.include?( jid )
          self.class.connection.remove( jid )
        end
      end

      # Add missing contacts
      self.class.contacts.each do |contact|
        unless self.class.connection.subscribed_to?( contact )
          self.class.befriend_contact!( contact )
        end
      end
    end

    def setup_pools!
      if File.exists?( RATPACK_ROOT + '/config/pools.yml' )
        groups = YAML::load_file( RATPACK_ROOT + '/config/pools.yml' )

        @pools = groups.inject({}) do |memo, group|
          memo[ group.shift ] = Pool.new( *group.shift )
          memo
        end
      else
        @pools = {}
      end
    end
  end
end