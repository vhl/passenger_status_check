require 'ostruct'
require 'passenger_status_check/process'

module PassengerStatusCheck
  class Parser
    attr_reader :xml

    def initialize(file_path)
      @data = File.read(file_path)
    end

    def xml
      @xml ||= Ox.parse(@data)
    end

    def processes
      @processes ||= xml.locate("info/supergroups/supergroup/group/processes/process/").map do |process_xml|
        Process.new(process_xml)
      end
    end

    def process_count
      xml.locate('info/supergroups/supergroup/group/processes/process').size
    end

    def requests_in_top_level_queue
      xml.locate("info/get_wait_list_size/*").first
    end

    def requests_in_app_queue
      xml.locate("info/supergroups/supergroup/group/get_wait_list_size/*").first
    end
  end
end
