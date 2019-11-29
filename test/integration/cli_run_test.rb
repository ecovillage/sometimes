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

  def test_creates_file_only_daily
    timelock = Date.civil(2019,2,2)
    ssh_mock = "touch backups/def/daily/20190202_0000.tgz"

    in_mock_time_jail(timelock, ssh_mock) do
      definition = Sometimes::BackupDefinition.new(
        path: 'backups/def',
        key:  'key',
        store_size: {
          daily:   1,
          weekly:  0,
          monthly: 0,
          yearly:  0
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

      [:daily].each do |s|
        expected_file_path = File.join('backups/def', s.to_s, '20190202_0000.tgz')
        assert File.exist?(expected_file_path)
      end
      [:monthly, :weekly, :yearl].each do |s|
        expected_file_path = File.join('backups/def', s.to_s, '20190202_0000.tgz')
        refute File.exist?(expected_file_path)
      end

      assert File.symlink?('backups/def/last.tgz')
    end
  end
end
