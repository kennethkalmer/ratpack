# Simple ratpack client using the HTTParty gem
#

require 'rubygems'
require 'httparty'

# Simple HTTParty wrapper for interacting with ratpack
class RatpackClient
  include HTTParty

  base_uri 'http://localhost:4567' # URL o your ratpack

  class << self
    
    # Send a single +message+ to the specified +jid+
    def message( jid, message )
      post('/message', :body => { :to => jid, :message => message })
    end
    
    # Send a message to multiple recipients
    def broadcast( message, *recipients )
      post('/broadcast', :body => { :message => message, :recipients => recipients } )
    end
    
    # Send a message to a pool
    def pool( pool, message )
      post('/pool', :body => { :pool => pool, :message => message } )
    end
  end
  
end
