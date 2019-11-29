module Sometimes
  module Shell
    module SSH
      def self.build_command key_path, user, host, sink
        "ssh -i #{key_path} #{user}@#{host} > #{sink}"
      end
    end
  end
end
