
require 'daemons'

module FireAndForget
  module Command
    class Fire < CommandBase
      attr_reader :niceness, :task_uid, :task_gid

      def initialize(task, params={})
        super
        @task_uid = Process.euid
        @task_gid = Process.egid
      end

      def niceness
        @task.niceness
      end

      def binary
        @task.binary
      end

      def cmd
        %(#{binary} #{FireAndForget.to_arguments(@params)})
      end

      def valid?
        exists? && permitted?
      end

      def permitted?
        raise PermissionsError, "'#{binary}' does not belong to user '#{ENV["USER"]}'" unless File.stat(binary).uid == task_uid
        true
      end

      def exists?
        raise FileNotFoundError, "'#{binary}'" unless File.exists?(binary)
        true
      end

      def run
        if valid?
          pid = fork do
            Daemons.daemonize(:backtrace => true)
            Process.setpriority(Process::PRIO_PROCESS, 0, niceness) if niceness > 0
            # change to the UID of the originating thread
            Process::GID.change_privilege(task_gid)
            Process::UID.change_privilege(task_uid)
            exec(cmd)
          end
          Process.detach(pid) if pid
          pid
        end
      end
    end
  end
end

