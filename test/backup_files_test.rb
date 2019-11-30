require "test_helper"
require 'test_construct'

require 'date'

require 'timecop'

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

  def test_most_recent_backup_date
    within_construct do |construct|
      construct.directory('backups/def/yearly') do |dir|
        dir.file('2018-01-01_1000.tgz')
      end
      construct.directory('backups/def/weekly') do |dir|
        dir.file('2019-01-01_0922.tgz')
      end
      construct.directory('backups/def/monthly') do |dir|
        dir.file('2019-01-01_1000.tgz')
      end
      construct.directory('backups/def/daily') do |dir|
        dir.file('2019-01-01_0922.tgz')
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

      most_recent = Sometimes::BackupFiles.last_backup_date(definition)

      assert_equal most_recent, DateTime.civil(2019, 1, 1, 10, 0)
    end
  end

  def test_oldest_date_in
    within_construct do |construct|
      construct.directory('backups/def/yearly') do |dir|
        dir.file('2018-01-01_1000.tgz')
        dir.file('2019-01-01_0922.tgz')
        dir.file('2019-01-01_1000.tgz')
      end
      construct.directory('backups/def/weekly') do |dir|
        dir.file('2018-01-01_1000.tgz')
        dir.file('2019-01-01_0922.tgz')
        dir.file('2019-01-01_1000.tgz')
      end
      construct.directory('backups/def/monthly') do |dir|
        dir.file('2018-01-01_1000.tgz')
        dir.file('2019-01-01_0922.tgz')
        dir.file('2019-01-01_1000.tgz')
      end
      construct.directory('backups/def/daily') do |dir|
        dir.file('2018-01-01_1000.tgz')
        dir.file('2019-01-01_0922.tgz')
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
      oldest_func = Sometimes::BackupFiles.method(:oldest_date_in).curry[definition]
      [:weekly, :monthly, :yearly].each do |s|
        assert_equal oldest_func[s], DateTime.civil(2019, 1, 1, 10, 0)
      end

      assert_equal oldest_daily, DateTime.civil(2019, 1, 1, 10, 0)
    end
  end

  def test_age_of_in_units
    within_construct do |construct|
      construct.directory('backups/def/yearly') do |dir|
        dir.file('2018-01-01_1000.tgz')
        dir.file('2019-01-01_0922.tgz')
        dir.file('2019-01-01_1000.tgz')
      end
      construct.directory('backups/def/weekly') do |dir|
        dir.file('2018-01-01_1000.tgz')
        dir.file('2019-01-01_0922.tgz')
        dir.file('2019-01-01_1000.tgz')
      end
      construct.directory('backups/def/monthly') do |dir|
        dir.file('2018-01-01_1000.tgz')
        dir.file('2019-01-01_0922.tgz')
        dir.file('2019-01-01_1000.tgz')
      end
      construct.directory('backups/def/daily') do |dir|
        dir.file('2018-01-01_1000.tgz')
        dir.file('2019-01-01_0922.tgz')
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

      date = Date.civil(2019,10,1)
      Timecop.freeze(date) do
        assert_equal(
          272.5,
          Sometimes::BackupFiles.age_of_in_units(definition, :daily).to_f,
          "age in days incorrect")
        assert_equal(
          38,
          Sometimes::BackupFiles.age_of_in_units(definition, :weekly).to_i,
          "age in weeks incorrect")
        assert_equal(
          8,
          Sometimes::BackupFiles.age_of_in_units(definition, :monthly).to_i,
          "age in months incorrect")
        assert_equal(
          0,
          Sometimes::BackupFiles.age_of_in_units(definition, :yearly).to_i,
          "age in years incorrect")
      end
    end

  end
end
