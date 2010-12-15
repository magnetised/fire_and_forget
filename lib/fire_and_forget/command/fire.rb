
require 'daemons'

module FireAndForget
  module Command
    class Fire < CommandBase
      attr_reader :niceness

      def niceness
        @task.niceness
      end

      def binary
        @task.binary
      end

      def cmd
        %(#{binary} #{FAF.to_arguments(@params)})
      end

      def permitted?
        File.exists?(binary) && File.owned?(binary)
      end

      def run
        if permitted?
          pid = fork do
            Daemons.daemonize(:backtrace => true)
            Process.setpriority(Process::PRIO_PROCESS, 0, niceness) if niceness > 0
            exec(cmd)
          end
          Process.detach(pid) if pid
          pid
        else
          raise Errno::EACCES
        end
      end
    end
  end
end
