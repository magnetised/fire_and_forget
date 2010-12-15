
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

      def valid?
        exists? && permitted?
      end

      def permitted?
        raise Errno::EACCES.new("'#{binary}' does not belong to user '#{ENV["USER"]}'") unless File.owned?(binary)
        true
      end

      def exists?
        raise Errno::ENOENT.new("'#{binary}'") unless File.exists?(binary)
        true
      end

      def run
        if valid?
          pid = fork do
            Daemons.daemonize(:backtrace => true)
            Process.setpriority(Process::PRIO_PROCESS, 0, niceness) if niceness > 0
            exec(cmd)
          end
          Process.detach(pid) if pid
          pid
        end
      end
    end
  end
end

