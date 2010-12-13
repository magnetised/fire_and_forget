
require 'daemons'

module FireAndForget
  module Command
    class FireCommand < CommandBase
      attr_reader :niceness

      def parse_options
        @niceness = @options[0].to_i.abs rescue 0
      end

      def run
        pid = fork do
          Daemons.daemonize
          system("renice +#{niceness} #{$$}") if niceness > 0
          exec(command)
        end
        Process.detach(pid) if pid
        pid
      end
    end
  end
end
