require 'rubygems'
require 'bundler'
class BunnyTest
  # This intends to start a communication session with RabbitMQ
  # open a channel, declare a queue, publish a message to the default exchange which then gets routed to this queue
  # close the connection

  def self.publish  

    puts 'We will try to publish your message to RabbitMQ. To exit press CTRL + \'C\''

    puts 'Insert Object'
    object = gets.chomp
    if object.empty?
      puts 'Object will be empty'
    end
    puts 'Insert Method Name'
    methodName = gets.chomp
    if methodName.empty?
      puts 'Method Name cannot be empty'
      publish
    end
    puts "Message Count (default 1)"
    count = gets.chomp

    correlation_id = (0...30).map { (65 + rand(26)).chr }.join

    a = Array.new
    a = object.split ','
    b = Hash.new
    a.each do |obj| 
      k, v = obj.split '='
      b[k] = v
    end
    payload = Oj.dump(b)
    puts "Connecting to Bunny"
    conn = Bunny.new(:host => $rabbit_host, :port => $rabbit_port, :user => $rabbit_user, :pass => $rabbit_pass)
    conn.start
    ch = conn.channel
    q  = ch.queue("#{$rabbit_queue_prefix}-#{$rabbit_queue}-#{$rabbit_queue_suffix}", {durable: true})
    puts "Publishing the message with method and object"
    count.to_i.times do 
      q.publish(
      payload,
      :headers => {
        :methodName => methodName
        },
      :reply_to => 'test_response_queue',
      :correlation_id => correlation_id,
      :delivery_mode => 1
    )
    end
    conn.stop
    puts "\e[H\e[2J"
    publish
  end
  publish
end