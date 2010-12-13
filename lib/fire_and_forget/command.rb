
module FireAndForget
  module Command
    SEPARATOR = "||".freeze

    def self.parse(command)
      action, tag, *parts = command.split(SEPARATOR)
      binary = parts[-1]
      options = parts[0..-2]
      klass = self.const_get("#{action.capitalize}Command")
      klass.new(tag, binary, options)
    end

    class CommandBase
      attr_reader :tag, :command

      def initialize(tag, command, options=nil)
        @tag, @command, @options = tag, command, options
        parse_options if @options
      end

      def run
        # overridden in subclasses
      end

      def parse_options
        # overridden in subclasses
      end
    end
    autoload :FireCommand, "fire_and_forget/command/fire_command"
  end
end
