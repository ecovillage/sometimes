require 'date'
require 'pathname'

module Sometimes
  module BackupFiles
    def self.monthly definition
      #[ , ]
    end

    def self.path_to_file_now definition, scheme
      #store_path = "#{definition.path}/#{scheme.to_s}"
      now = "#{DateTime.now.strftime('%F_%H%M')}"
      extension = Sometimes::FileEnvironment.file_extension(definition)
      store_path = File.join(definition.path, scheme.to_s, now + "." + extension)
    end

    def self.link_last! definition, file
      last_file_link = Sometimes::FileEnvironment.last_file_link_path(definition)

      # First, remove old link.
      Sometimes::Shell.execute("rm #{last_file_link}")

      # Create new link.
      Sometimes::Shell.execute("ln -s #{file} #{last_file_link}")
    end
  end
end
