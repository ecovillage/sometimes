module Sometimes
  module CLI
    def self.run_on definition
      Sometimes::FileEnvironment.prepare! definition
      now = DateTime.now

      target_file = BackupFiles.path_to_file_now definition, :daily

      ssh_cmd = Sometimes::Shell::SSH.build_command(
        definition.key,definition.user, definition.host, target_file)

      Sometimes::Shell.execute ssh_cmd
    end
  end
end
