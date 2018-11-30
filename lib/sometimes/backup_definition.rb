module Sometimes
  class BackupDefinition
    attr_reader :path, :key, :comment, :store_size, :user, :host, :type, :what, :version, :type

    def initialize path: nil, key: nil, comment: nil,
      store_size: {}, user: nil, host: nil, what: nil,
      type: 'tgz', version: 1
      @path    = File.expand_path path if path
      @key     = File.expand_path key  if key
      @comment = comment
      @store_size = store_size
      @user    = user
      @host    = host
      @what    = what
      @version = version.to_i
      @type    = type
    end

    def path
      # or Pathname.new()
      File.expand_path @path
    end

    def key
      File.expand_path @key
    end
end
