require "test_helper"

class FileEnvironmentTest < Minitest::Test
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
end

