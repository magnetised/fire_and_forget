

module FireAndForget
  class Task
    attr_reader :name, :binary, :niceness, :params

    def initialize(name, path_to_binary, default_parameters={}, niceness=0)
      @name, @binary, @params, @niceness = name, path_to_binary, default_parameters, niceness
    end
  end
end
