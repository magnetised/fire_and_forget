
module FireAndForget
  module Command
    SEPARATOR = "||".freeze

    def self.load(command)
      Marshal.load(command)
    end

    class CommandBase
      attr_reader :tag, :cmd, :params, :task

      def initialize(task, params={})
        @task, @params = task, merge_params(task.params, params)
      end

      def dump
        Marshal.dump(self)
      end

      def run
        # overridden in subclasses
      end


      def merge_params(task_params, call_params)
        params = task_params.to_a.inject({}) do |hash, (key, value)|
          hash[key.to_s] = value; hash
        end
        call_params.each do |key, value|
          params[key.to_s] = value
        end if call_params
        params
      end
    end

    autoload :FireCommand, "fire_and_forget/command/fire_command"
    autoload :SetStatus, "fire_and_forget/command/set_status"
    autoload :GetStatus, "fire_and_forget/command/get_status"
  end
end
