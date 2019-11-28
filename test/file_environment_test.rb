require "test_helper"
require 'test_construct'

class FileEnvironmentTest < Minitest::Test
  include TestConstruct::Helpers

  def test_path_to_last_file
    definition = Sometimes::BackupDefinition.new path: '/backups/def/'
    assert_equal '/backups/def/last.tgz', Sometimes::FileEnvironment.last_file_link_path(definition)
  end

  def test_file_extension
    definition = Sometimes::BackupDefinition.new type: 'tgz'
    assert_equal 'tgz', Sometimes::FileEnvironment.file_extension(definition)
    definition = Sometimes::BackupDefinition.new type: 'mysql'
    assert_equal 'sql', Sometimes::FileEnvironment.file_extension(definition)
  end

  def test_prepare!
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

      Sometimes::FileEnvironment.prepare! definition

      assert File.exist? 'backups'
      assert File.directory? 'backups/def'
      assert File.directory? 'backups/def/daily'
    end
  end
end

