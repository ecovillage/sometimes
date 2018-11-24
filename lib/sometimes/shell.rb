require 'shellwords'

module Sometimes
  module Shell
    # Shellescape what comes in, return as Array.
    def self.escape *values
      [*values].map {|a| Shellwords.escape v}
    end

    # Execute a command (via Kernel#system()), log command (debug).
    def self.execute command
      Sometimes.logger.debug "executing command:"
      Sometimes.logger.debug "  #{command}"
      system(command)
    end
  end
end
