require "sometimes/version"

require "sometimes/backup_definition"
require "sometimes/shell"
require "sometimes/cli/common"
require "sometimes/file_environment"
require "sometimes/environment_check"
require "sometimes/authorized_keys_file"
require "sometimes/store_cleaner"

require 'logger'

require 'tty-config'

module Sometimes
  # Struct?
  #class BackupDefinition
  #  rattr_initialize [:path, :key, :comment, :store_size, :user, :host, :type, :what, :version]
  #  # the store_size setter should symbolize keys
  #end

  def self.read_def name
    @@logger.debug("Loading definition file #{name}")

    config = TTY::Config.new
    config.read name, format: :yaml

    BackupDefinition.new(path:    config.fetch(:path),
                         key:     config.fetch(:key ),
                         comment: config.fetch(:comment),
                         store_size: config.fetch(:store_size),
                         user:    config.fetch(:user),
                         host:    config.fetch(:host),
                         type:    config.fetch(:type),
                         what:    config.fetch(:what),
                         version: config.fetch(:version))
  end

  def self.logger
    @@logger ||= Logger.new(STDOUT).tap{|l| l.level == Logger::INFO}
  end
end
