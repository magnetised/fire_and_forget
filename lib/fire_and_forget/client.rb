module FireAndForget
  class Client



    class << self
      def run(cmd)
        result = open_connection do |connection|
          connection.send(cmd.dump, 0)
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
end
