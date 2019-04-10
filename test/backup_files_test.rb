require "test_helper"

require 'date'

class BackupFilesTest < Minitest::Test
  def test_path_to_file_now
    definition = Sometimes::BackupDefinition.new path: '/backups/def'
    path_now = Sometimes::BackupFiles.path_to_file_now definition, :daily
    now = "#{DateTime.now.strftime('%F_%H%M')}"
    assert_equal "/backups/def/daily/#{now}.tgz", path_now
  end
end
