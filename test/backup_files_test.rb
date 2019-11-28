require "test_helper"
require 'test_construct'

require 'date'

class BackupFilesTest < Minitest::Test
  include TestConstruct::Helpers

  def test_path_to_file_now
    definition = Sometimes::BackupDefinition.new path: '/backups/def'
    path_now = Sometimes::BackupFiles.path_to_file_now definition, :daily
    now = "#{DateTime.now.strftime('%F_%H%M')}"
    assert_equal "/backups/def/daily/#{now}.tgz", path_now
  end

  def test_store_path
    definition = Sometimes::BackupDefinition.new(
      path: 'backups/def'
    )
    assert_equal File.join(Dir.pwd, 'backups/def/daily'),
      Sometimes::BackupFiles.store_path(definition, :daily)
  end

  def test_oldest_date_in
    within_construct do |construct|
      construct.directory('backups/def/daily') do |dir|
        dir.file('2019-01-01_1000.tgz')
      end

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

      oldest_daily = Sometimes::BackupFiles.oldest_date_in(definition, :daily)

      assert_equal oldest_daily, DateTime.civil(2019, 1, 1, 10, 0)
    end
  end
end
