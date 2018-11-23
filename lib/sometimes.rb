require "sometimes/version"

require 'tty-config'
require 'attr_extras'

module Sometimes
  # Struct?
  class BackupDefinition
    rattr_initialize :path, :key, :comment, :store_size, :user, :host, :type, :what
  end

  def self.read_def name
    config = TTY::Config.new
    config.read name
    BackupDefinition.new(config.fetch(:path),
                         config.fetch(:key ),
                         config.fetch(:comment),
                         config.fetch(:store_size),
                         config.fetch(:user),
                         config.fetch(:host),
                         config.fetch(:type),
                         config.fetch(:what))
  end
end
