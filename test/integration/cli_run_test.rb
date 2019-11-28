require "test_helper"
require 'test_construct'

require 'sometimes/cli'

class CliRunTest < Minitest::Test
  include TestConstruct::Helpers

  def test_creates_file
    within_construct do |construct|
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

      #Sometimes::FileEnvironment.prepare! definition
      Sometimes::CLI.run_on definition

      assert File.exist? 'backups'
      assert File.directory? 'backups/def'
      assert File.directory? 'backups/def/daily'
    end
  end
end
