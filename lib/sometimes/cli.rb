require 'fileutils'

module Sometimes
  module CLI
    def self.run_on definition
      Sometimes::FileEnvironment.prepare! definition
      now = DateTime.now

      # TODO: might not always end up in monthly!
      target_file = BackupFiles.path_to_file_at definition, :daily, now

      ssh_cmd = Sometimes::Shell::SSH.build_command(
        definition.key,definition.user, definition.host, target_file)

      Sometimes::Shell.execute ssh_cmd

      # TODO daily already done
      if weekly_needed? definition
        FileUtils.cp target_file, Sometimes::BackupFiles.path_to_file_at(definition, :weekly, now)
      end
      if monthly_needed? definition
        FileUtils.cp target_file, Sometimes::BackupFiles.path_to_file_at(definition, :monthly, now)
      end
      if yearly_needed? definition
        FileUtils.cp target_file, Sometimes::BackupFiles.path_to_file_at(definition, :yearly, now)
      end

      Sometimes::BackupFiles.link_last! definition, target_file
    end

    def self.daily_needed? definition
      file_in_scheme_needed? definition, :weekly
    end

    def self.weekly_needed? definition
      file_in_scheme_needed? definition, :weekly
    end

    def self.monthly_needed? definition
      file_in_scheme_needed? definition, :monthly
    end

    def self.yearly_needed? definition
      file_in_scheme_needed? definition, :yearly
    end

    def self.file_in_scheme_needed? definition, scheme
      rate = definition.store_size[scheme]

      if rate && rate >= 1
        age = Sometimes::BackupFiles.age_of_in_units(definition, scheme)

        age >= 1
      else
        false
      end
    end
  end
end
