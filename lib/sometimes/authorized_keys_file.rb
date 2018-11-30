module Sometimes
  module AuthorizedKeysFile
    # The command that should be executed on remote host
    # (to be specified via command='' in authorized_keys file).
    def self.command definition
      shescape = lambda {|v| Shellwords.escape v}
      Sometimes::logger.debug("Type: #{definition.type}")

      case definition.type
      when 'tgz'
        Sometimes::logger.debug("Creating tgz authorized keys line")
        what_path = File.expand_path definition.what
        "tar -cz --file - --ignore-command-error "\
          "--ignore-failed-read %s 2>/dev/null" %
          [shescape.call(what_path)]
      when 'mysql'
        # In users ~/.my.cnf
        # [mysqldump]
        # user=mysqluser
        # password=secret
        Sometimes::logger.debug("Creating mysql authorized keys line")
        "mysqldump --single-transaction --quick --lock-tables=false #{definition.what}"
      else
        Sometimes::logger.warn("Do not know how to deal with command type #{definition.type}")
      end
    end

    def self.line definition
      key_path = File.expand_path definition.key
      what_path = File.expand_path definition.what
      pub_key   = File.read(key_path + ".pub")
      shescape = lambda {|v| Shellwords.escape v}

      authorized_keys = "command=\"%s\",restrict %s" %
        [command(definition), pub_key]
      
      # TODO sanity check, result check
      #File.open(key_path + ".authorized_keys.command", 'w') {|f| f.write(authorized_keys) }
    end
  end
end
