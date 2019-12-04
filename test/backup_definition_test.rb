require "test_helper"

class BackupDefinitionTest < Minitest::Test
  def test_full_initialization
    definition = Sometimes::BackupDefinition.new(
      path: '/backups/def/',
      key:  '/key',
      store_size: {daily: 1, weekly: 2, monthly: 3, yearly: 4},
      user: 'backupper',
      host: '12.211.2.1',
      comment: 'exaback files',
      type: 'tgz',
      what: '/var/exaback',
      version: '1',
    )
    assert_equal definition.type, 'tgz'
    assert_equal definition.path, '/backups/def'
    assert_equal definition.key,  '/key'
    store_sizes = {"daily" => 1, "weekly" => 2, "monthly" => 3, "yearly" => 4}
    assert_equal store_sizes, definition.store_size
    assert_equal definition.store_size[:daily],    1
    assert_equal definition.store_size[:weekly  ], 2
    assert_equal definition.store_size[:monthly ], 3
    assert_equal definition.store_size[:yearly  ], 4
    assert_equal definition.user, 'backupper'
    assert_equal definition.host, '12.211.2.1'
    assert_equal definition.what, '/var/exaback'
    assert_equal definition.version, 1
  end

  def test_path_setting
    definition_no_slash = Sometimes::BackupDefinition.new(
      path: '/backups/def',
      key:  '/key',
    )
    assert_equal definition_no_slash.path, '/backups/def'
    assert_equal definition_no_slash.key,  '/key'
    definition_slash = Sometimes::BackupDefinition.new(
      path: '/backups/def/',
      key:  '/key/',
    )
    assert_equal definition_no_slash.path, '/backups/def'
    assert_equal definition_no_slash.key,  '/key'
  end

  def test_store_size_indifferent_access
    definition = Sometimes::BackupDefinition.new(
      path: '/backups/def/',
      key:  '/key',
      store_size: {daily: 1, weekly: 2, monthly: 3, yearly: 4}
    )
    assert_equal 1, definition.store_size[:daily]
    assert_equal 1, definition.store_size["daily"]
  end

  # TODO store_size indifferent access
end
