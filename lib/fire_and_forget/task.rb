

module FireAndForget
  class Task
    attr_reader :name, :binary, :niceness

    def initialize(name, path_to_binary, default_parameters={}, niceness=0)
      @name, @binary, @default_parameters, @niceness = name, path_to_binary, default_parameters, niceness
    end

    def command(params={})
      %(fire||#{name}||#{niceness}||#{binary} #{FAF.to_arguments(merge_params(params))})
    end

    def merge_params(call_params)
      params = @default_parameters.to_a.inject({}) do |hash, (key, value)|
        hash[key.to_s] = value; hash
      end
      call_params.each do |key, value|
        params[key.to_s] = value
      end
      params
    end
  end
end
