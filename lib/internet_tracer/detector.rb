require 'net/http'
require 'uri'

module InternetTracer
  class Detector
    attr_accessor :status_url, :regexp_main, :regexp_left, :regexp_right, :check_period, :debug
    
    def initialize
      @status_url = "http://192.168.0.1/"
      @check_period = 20
      
      # Default is IP address regexp
      @regexp_main = /[0-9]{1,3}(\.[0-9]{1,3}){3}/
      
      # Empty regexps to catch the first IP address on the page by default
      @regexp_left = //
      @regexp_right = //
      
      @debug = false
    end

    def wait_for_normal_ip(check_period = @check_period)
      loop do
        begin
          ip = get_real_ip
        rescue
          puts "Rescued from: #{$!}" if @debug
        end 
        
        break ip if ip && ip != "0.0.0.0"
        yield(ip) if block_given?
        sleep check_period
      end
    end
    
    def get_real_ip
      match = Net::HTTP.get(URI.parse(@status_url)).match(search_regexp)
      raise "IP address was not found on the page!" unless match
      match[:value]
    end
    
    def set_regexp(values = {})
      values = { :main => values } if values.kind_of?(Regexp) || values.kind_of?(String)
      @regexp_left = values[:left] if values[:left]
      @regexp_main = values[:main] if values[:main]
      @regexp_right = values[:right] if values[:right]
      self
    end
    
    
    def search_regexp
      /#{@regexp_left}(?<value>#{@regexp_main})#{@regexp_right}/
    end
    
    def to_s
      puts "#<#{self.class.to_s}:"
      puts "  URL: #{@status_url}"
      puts "  Check period: #{@check_period}"
      puts
      puts "  Main regexp: #{@regexp_main.inspect}"
      puts "  Left regexp: #{@regexp_left.inspect}"
      puts "  Right regexp: #{@regexp_right.inspect}"
      puts
      puts "  Resulting regexp: #{search_regexp.inspect}"
      puts ">"
    end
  end

end
