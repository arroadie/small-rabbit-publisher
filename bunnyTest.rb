class BunnyTest
	# This intends to start a communication session with RabbitMQ
	# open a channel, declare a queue, publish a message to the default exchange which then gets routed to this queue
	# close the connection

	def self.publish	

		puts 'We will try to publish your message to RabbitMQ. To exit press CTRL + \'C\''

		puts 'Insert Object'
		object = gets.chomp
		if object.empty?
			puts 'Object cannot be empty'
			publish
		end

		puts 'Insert Method Name'
		methodName = gets.chomp
		if methodName.empty?
			puts 'Method Name cannot be empty'
			publish
		end

		puts "Connecting to Bunny"
		conn = Bunny.new(:host => $rabbit_host, :port => $rabbit_port, :user => $rabbit_user, :pass => $rabbit_pass)
		conn.start
		ch = conn.channel
		q  = ch.queue($rabbitQueue, :exclusive => false, :auto_delete => true)
		puts "Publishing the message with method and object"
		q.publish(
			"id:#{object}",
			:headers => {
				:method => "#{methodName}"
				}
		)
		conn.stop
		puts "\e[H\e[2J"
		publish
	end
	publish
end