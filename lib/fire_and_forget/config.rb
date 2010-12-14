module FireAndForget
  module Config
    attr_accessor :port
    attr_accessor :bind_address

    def port
      @port ||= FAF::DEFAULT_PORT
    end

    def bind_address
      @bind_address ||= "127.0.0.1"
    end
  end
end

