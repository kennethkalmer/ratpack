require 'rubygems'
require 'mq'

# Simple client, empties the test queue on localhost
AMQP.start do
  
  def log *args
    p [ Time.now, *args ]
  end

  
  amq = MQ.new
  amq.queue('test').subscribe do |msg|
    log 'test', 'received', msg
  end
  
end
