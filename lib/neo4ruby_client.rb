require 'bunny'

class Neo4rubyClient
  attr_reader :reply_queue

  def open(server_queue_name)
    open_channel
    create_exchange(server_queue_name)
  end

  def close
    @ch.close
    @conn.close
  end

  def call(page, uid = nil)
    correlation_id = (uid || generate_uuid(page))

    @exchange.publish(page,
      :routing_key    => @server_queue,
      :correlation_id => correlation_id,
      :reply_to       => @reply_queue.name)

    response = nil
    @reply_queue.subscribe(:block => true) do |delivery_info, properties, payload|
      if properties[:correlation_id] == correlation_id
        response = payload.to_i

        delivery_info.consumer.cancel
      end
    end

    response
  end

  private

  def generate_uuid(object)
    "neo4r#{object.object_id}"
  end

  def open_channel
    @conn = Bunny.new
    @conn.start
    @ch = @conn.create_channel
  end

  def create_exchange(server_queue_name)
    @exchange = @ch.default_exchange

    @server_queue   = server_queue_name
    @reply_queue    = @ch.queue("", :exclusive => true)
  end
end
