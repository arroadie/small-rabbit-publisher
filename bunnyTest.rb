class BunnyTest
	# This intends to start a communication session with RabbitMQ
	# open a channel, declare a queue, publish a message to the default exchange which then gets routed to this queue
	# close the connection

	def self.publish	

		puts 'Insert Object'
		object = gets.chomp
		puts 'Insert Method Name'
		methodName = gets.chomp

		conn = Bunny.new(:host => $rabbit_host, :port => $rabbit_port, :user => $rabbit_user, :pass => $rabbit_pass)
		conn.start
		ch = conn.channel
		q  = ch.queue($rabbitQueue, :exclusive => false, :auto_delete => true)
		q.publish(
			"id:#{object}",
			:headers => {
				:method => "#{methodName}"
				}
			)
		conn.stop

		publish
	end
	publish
end