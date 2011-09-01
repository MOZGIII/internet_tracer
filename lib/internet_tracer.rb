require "internet_tracer/version"
require "internet_tracer/detector"
require "internet_tracer/core_ext/string"
require "optparse"
require "ostruct"

module InternetTracer

  class App

    def detector
      @detecor ||= Detector.new    
    end
    
    def initialize
      ["INT", "TERM"].each do |signame|
        trap(signame) do
          puts "Caught SIG#{signame}"
          exit
        end
      end
    end

    def run      
      options = OpenStruct.new
      options.verbose = false
      options.notify = true
      optparse = OptionParser.new do |opts|   
        opts.banner = "Usage: internet-trace [options]"        
        opts.separator "Example usage: internet-trace -l \"/#{'\\<div id="wan_ip"\\>.*?'}/i\" -u \"http://router.local/status\""

        opts.separator ""
        opts.separator "Regexp options:"        
        
        opts.on( '-l', '--left REGEXP', 'Allows to set left regexp', " Default: #{detector.regexp_left.inspect}" ) do |regexp|
          detector.set_regexp(:left => regexp.to_regexp)
        end
        
        opts.on( '-r', '--right REGEXP', 'Allows to set right regexp', " Default: #{detector.regexp_right.inspect}" ) do |regexp|
          detector.set_regexp(:right => regexp.to_regexp)
        end
        
        opts.on( '-m', '--main REGEXP', 'Allows to set main regexp (used for the new IP address value)', " Default: #{detector.regexp_main.inspect}" ) do |regexp|
          detector.set_regexp(:main  => regexp.to_regexp)
        end
        
        opts.separator ""
        opts.separator "Specific options:"
        
        opts.on( '-u', '--url URL', 'Specifies the checked page url', " Default: #{detector.status_url}" ) do |url|
          detector.status_url = url
        end
        
        opts.on( '-p', '--period SECONDS', 'How frequently should checks happen, in seconds', " Default: #{detector.check_period}" ) do |seconds|
          detector.check_period = seconds.to_i
        end
        
        opts.on( '--no-notify', 'Disable notification on success (only notifies if "notify-send" command is available)' ) do
          options.notify = false
        end
           
        opts.separator ""
        opts.separator "Other options:" 
                
        opts.on( '--[no-]verbose', 'Run verbosely' ) do |v|
          options.verbose = v
        end
                   
        opts.on( '--debug', 'Debug mode' ) do
          options.verbose = true
          detector.debug = true
        end
        
        opts.separator ""
        opts.separator "Presets:"   
         
        opts.on( '-w', '--dd-wrt', 'Use preset for DD-WRT' ) do
          detector.set_regexp(:left => /\<span id="ipinfo"\>.*?/, :right => //, :main => /[0-9]{1,3}(\.[0-9]{1,3}){3}/)
        end  
        
        opts.separator ""
        opts.separator "Common options:"

        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        # Another typical switch to print the version.
        opts.on_tail("-v", "--version", "Show version") do
          puts VERSION
          exit
        end
      end
      optparse.parse!
      
      puts detector if detector.debug
      
      ip = detector.wait_for_normal_ip do |wrong_ip|
        puts "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} - No luck this time... (got: #{wrong_ip})" if options.verbose
      end

      puts "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} - Ok, we're happy!" if options.verbose
      puts "New IP is: #{ip}"

      # Using notify-send to send notification, should give no problem even without libnotify
      system("notify-send", "Internet in now connected!", "Your IP is: #{ip}") if options.notify
    end
    
  end
  
  def self.run
    App.new.run
  end
  
end
