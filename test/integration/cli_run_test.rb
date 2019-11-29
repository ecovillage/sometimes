require "test_helper"
require 'test_construct'

require 'sometimes/cli'

class CliRunTest < Minitest::Test
  include TestConstruct::Helpers

  def in_mock_time_jail date, ssh_command
    within_construct do |construct|
      Sometimes::Shell::SSH.stub :build_command, ssh_command do
        Timecop.freeze(date) do
          yield
        end
      end
    end
  end

  def test_creates_file
    timelock = Date.civil(2019,2,2)
    ssh_mock = "touch backups/def/daily/20190202_0000.tgz"

    in_mock_time_jail(timelock, ssh_mock) do
      definition = Sometimes::BackupDefinition.new(
        path: 'backups/def',
        key:  'key',
        store_size: {
          daily:   1,
          weekly:  1,
          monthly: 1,
          yearly:  1
        },
        type: 'tgz',
        version: 1
      )

      refute File.exist? 'backups'
      refute File.directory? 'backups/def'
      refute File.directory? 'backups/daily'

      Sometimes::CLI.run_on definition

      assert File.exist? 'backups'
      assert File.directory? 'backups/def'
      assert File.directory? 'backups/def/daily'

      s = :daily
      expected_file_path = File.join('backups/def', s.to_s, '20190202_0000.tgz')
      assert File.exist?(expected_file_path)
    end
  end
end
