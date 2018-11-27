module Sometimes
  module StoreCleaner
    # schedule/scheme: daily, weekly, monthly, yearly
    def self.clean! definition, scheme
      # TODO Sanitize to integer and path
      # TODO File.expand_path ...
      store_path = "#{definition.path}/#{scheme.to_s}"
      keep_nr = definition.store_size[scheme.to_s]

      Sometimes::logger.debug("Clean up old copies")
      cleanup_cmd = "ls -tp #{store_path} | grep -v '/$' | tail -n +#{keep_nr.to_i + 1} | xargs -I {} rm -- #{store_path}/{}"
      
      Sometimes::Shell.execute(cleanup_cmd)
    end
  end
end
