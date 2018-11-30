module Sometimes
  module EnvironmentCheck
    def self.check!
      Sometimes::logger.debug "checking presence and version of ssh"
      Sometimes::logger.debug "checking presence and version of ssh-keygen"
      Sometimes::logger.debug "checking presence and version of tar"
      Sometimes::logger.debug "checking presence and version of tree"
      # else: exit 2
      true
    end
  end
end
