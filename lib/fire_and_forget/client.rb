module FireAndForget
  class Client

    attr_reader :port, :task, :params

    def initialize(task, params={})
      @task, @params = task, params
    end

    def fire
      result = open_connection do |client|
        client.send(task.command(params), 0)
      end

    end

    def open_connection
      connection = result = nil
      begin
        connection = TCPSocket.open(FAF.bind_address, FAF.port)
        yield(connection)
        connection.flush
        connection.close_write
        result = connection.read

      ensure
        connection.close if connection rescue nil
      end
      result
    end
  end
end

