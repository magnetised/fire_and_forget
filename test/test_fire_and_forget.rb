require 'helper'

class TestFireAndForget < Test::Unit::TestCase
  context "Utilities" do
    should "translate a hash to command line arguments" do
      FAF.to_arguments({
        :param1 => "value1",
        :param2 => "value2",
        :array => [1, 2, "3 of 4"],
        :hash  => {:name => "Fred", :age => 23}
      }).should == %(--array=1 2 "3 of 4" --hash=age:23 name:"Fred" --param1="value1" --param2="value2")
    end
  end
  context "configuration" do
    should "enable mapping of task to a binary" do
      FAF.add_task(:publish, "/path/to/binary")
      FAF.binary(:publish).should ==  "/path/to/binary"
      FAF[:publish].binary.should ==  "/path/to/binary"
    end

    should "enable setting of a niceness value for the task" do
      FAF.add_task(:publish, "/path/to/binary", 10)
      FAF[:publish].niceness.should ==  10
    end

    should "enable launching a task by its name" do
      FAF.add_task(:publish, "/path/to/binary")
      args = {:param1 => "param1", :param2 => "param2"}
      mock(FAF).fire(:publish, args)
      FAF.publish(args)
    end

    should "enable setting of path to socket" do
      FAF.socket = "/tmp/something"
      FAF.socket.should ==  "/tmp/something"
    end
    # should "enable setting of port for server" do
    #   FAF.port = 3007
    #   FAF.port.should == 3007
    # end

    # should "enable setting an address for the server" do
    #   FAF.bind_address = "10.0.1.10"
    #   FAF.bind_address.should == "10.0.1.10"
    # end
  end

  context "commands" do
    should "serialize and deserialize correctly" do
      task = FAF::TaskDescription.new(:publish, "/publish", 9, {:param1 => "value1", :param2 => "value2"})
      cmd = FAF::Command::CommandBase.new(task, {"param2" => "newvalue2", :param3 => "value3"})
      cmd2 = FAF::Command.load(cmd.dump)
      task2 = cmd2.task
      task2.binary.should == task.binary
      task2.params.should == task.params
      task2.name.should == task.name
      cmd.params.should == {"param1" => "value1", "param2" => "newvalue2", "param3" => "value3"}
    end
  end

  context "actions" do
    setup do
      @task = FAF::TaskDescription.new(:publish, "/publish", 9, {:param1 => "value1", :param2 => "value2"})
    end
    should "set status for a task" do
      cmd = FAF::Command::SetStatus.new(:publish, :doing)
      FAF::Server.run(cmd)
      cmd = FAF::Command::GetStatus.new(:publish)
      status = FAF::Server.run(cmd)
      status.should == "doing"
    end

    should "only run scripts belonging to the same user as the ruby process" do
      stub(File).exist?("/publish") { true }
      stub(File).exists?("/publish") { true }
      stat = Object.new
      stub(stat).uid { Process.uid + 1 }
      stub(File).stat("/publish") { stat }
      cmd = FAF::Command::Fire.new(@task)
      lambda { cmd.run }.should raise_error(FAF::PermissionsError)
    end

    should "not raise an error if the binary belongs to this process" do
      stat = Object.new
      stub(stat).uid { Process.uid }
      stub(File).stat("/publish") { stat }
      cmd = FAF::Command::Fire.new(@task)
      lambda { cmd.permitted? }.should_not raise_error(FAF::PermissionsError)
    end

    should "raise an error if the binary belongs to this process" do
      stat = Object.new
      uid = Process.uid
      stub(stat).uid { uid }
      stub(File).stat("/publish") { stat }
      stub(Process).euid { uid + 1 }
      cmd = FAF::Command::Fire.new(@task)
      lambda { cmd.permitted? }.should raise_error(FAF::PermissionsError)
    end

    should "give error if binary doesn't exist" do
      stub(File).exist?("/publish") { false }
      stub(File).exists?("/publish") { false }
      stub(File).owned?("/publish") { true }
      cmd = FAF::Command::Fire.new(@task)
      lambda { cmd.run }.should raise_error(FAF::FileNotFoundError)
    end

    should "raise error if command isn't one of the approved list" do
      cmd = Object.new
      mock(cmd).run.times(0)
      lambda { FAF::Server.run(cmd) }.should raise_error(FAF::PermissionsError)
    end
  end

  context "client" do
    should "send right command to server" do
      task = FAF.add_task(:publish, "/publish", {:param1 => "value1", :param2 => "value2"}, 12)
      command = Object.new
      mock(command).dump { "dumpedcommand" }
      mock(FAF::Command::Fire).new(task, {:param2 => "value3"}) { command }
      connection = Object.new
      mock(connection).send("dumpedcommand", 0)
      stub(connection).flush
      stub(connection).close_write
      mock(connection).read { "99999" }
      mock(connection).close
      FAF.socket = "/tmp/faf.sock"
      mock(UNIXSocket).open("/tmp/faf.sock") { connection }
      pid = FAF.publish({:param2 => "value3"})
      pid.should == "99999"
    end
  end

  context "server" do
    setup do
      @server = FAF::Server.new
    end

    should "run any command sent to it" do
      command = Object.new
      stub(FAF::Command).allowed? { true }
      mock(FAF::Command).load(is_a(String)) { command }
      mock(command).run { "666" }
      result = FAF::Server.parse("object")
      result.should == "666"
    end
  end
  context "daemon methods" do
    setup do
      class ::TaskDescriptionClass; end
    end
    teardown do
      Object.send(:remove_const, :TaskDescriptionClass) rescue nil
    end

    ## not sure how to test this
    # should "map a taskname to a pid when included" do
    #   mock(FAF::Client).run(satisfy { |cmd|
    #     (cmd.pid == $$) && (cmd.task_name == :tasking)
    #   })
    #   TaskDescriptionClass.send(:include, FAF::Daemon)
    # end
  end
end
