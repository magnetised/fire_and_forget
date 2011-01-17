module FireAndForget
  module Config
    attr_accessor :socket

    def socket
      @socket ||= FireAndForget::DEFAULT_SOCKET
    end
  end
end

