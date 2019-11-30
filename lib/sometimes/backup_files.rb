require 'date'
require 'pathname'

module Sometimes
  module BackupFiles
    def self.monthly definition
      #[ , ]
    end

    def self.oldest_date_in definition, scheme
      path_expr = File.join(store_path(definition, scheme), '**/*')
      last = Dir[path_expr]&.sort&.last
      if last
        strtime = File.basename(last, File.extname(last))
        DateTime.strptime strtime, "%F_%H%M"
      else
        nil
      end
    end

    def self.last_backup_date definition
    end

    # TODO beware we are wrong with "old", "new", and "last" terminology
    def self.age_of_in_units definition, scheme
      now = DateTime.now
      age = self.oldest_date_in(definition, scheme)
      if scheme == :daily
        now - age
      elsif scheme == :weekly
        (now - age) / 7.0
      elsif scheme == :monthly
        (now - age) / 30.5
      elsif scheme == :yearly
        (now - age) / 365
      end
    end

    def self.oldest_date definition
      dates = [:daily, :weekly, :monthly, :yearly].map do |scheme|
        self.oldest_date_in(definition, scheme)
      end.flatten
      dates.max
    end

    def self.store_path definition, scheme=nil
      File.join(definition.path, scheme.to_s)
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
