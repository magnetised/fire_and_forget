module FireAndForget
  module Config
    attr_accessor :socket

    def socket
      @socket ||= (ENV[FireAndForget::ENV_SOCKET] || FireAndForget::DEFAULT_SOCKET)
    end
  end
end

