require "sometimes/version"

require "sometimes/shell"

require 'logger'

require 'tty-config'
require 'attr_extras'

module Sometimes
  # Struct?
  class BackupDefinition
    rattr_initialize :path, :key, :comment, :store_size, :user, :host, :type, :what, :version
  end

  def self.read_def name
    config = TTY::Config.new
    config.read name, format: :yaml
    BackupDefinition.new(config.fetch(:path),
                         config.fetch(:key ),
                         config.fetch(:comment),
                         config.fetch(:store_size),
                         config.fetch(:user),
                         config.fetch(:host),
                         config.fetch(:type),
                         config.fetch(:what),
                         config.fetch(:version))
  end

  def self.logger
    @@logger ||= Logger.new(STDOUT)
  end
end
