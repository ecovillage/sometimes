require 'optparse'

module Sometimes
  module CLI
    module Common
      # Define an option parser and options, return in this order
      def self.option_parser
        options = {}
        $program_name = File.basename $PROGRAM_NAME
        
        optparse = OptionParser.new do |opts|
          opts.banner = "Usage: #{$program_name} [OPTIONS]"
          opts.separator ""
          # TODO more prose about what happens/will happen, exit codes...
        
          opts.separator "Sometimes definition"
          opts.on("-c", "--config FILE", 'file path to the (YAML) sometimes definition file.') do |c|
            if !File.exist? c
              STDERR.puts "Cannot load conf file #{c}"
              exit 2
            end
        
            options[:conf_file] = c
          end
        
          opts.separator ""
          opts.separator "General"
          opts.on("-v", "--verbose", 'do log verbose output') do |v|
            options[:verbose] = v
            Sometimes.logger.level = Logger::DEBUG
          end
        
          opts.on_tail('--version', 'Show version.') do
            puts "#{$program_name} #{Sometimes::VERSION}"
            exit 0
          end
          opts.on('-h', '--help', 'Show this help.') do
            puts opts
            exit 0
          end
        end

        #def optparse.read_definition
        #  Sometimes.read_def options[:conf_file]
        #end

        Sometimes::logger.debug("Starting #{$program_name} #{Sometimes::VERSION}")
        return [optparse, options]
      end
    end
  end
end
