require 'fileutils'

module Sometimes
  module FileEnvironment
    def self.prepare! definition
      definition.store_size.each do |name,_size|
        # TODO expand_path
        store_path = "#{definition.path}/#{name.to_s}"
        if !File.directory?(store_path)
          Sometimes::logger.debug("#{store_path} does not exist, creating")
          FileUtils.mkdir_p store_path # mkdirs
        else
          Sometimes::logger.debug("#{store_path} does already exist")
        end
      end
    end

    # path to link to last file
    def self.last_file_link_path definition
      File.expand_path(definition.path + "/last." + file_extension(definition))
    end

    # backup file extension
    def self.file_extension definition
      definition.type == 'mysql' ? 'sql' : 'tgz'
    end
  end
end
