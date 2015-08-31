require 'ostruct'
require 'passenger_status_check/process'

module PassengerStatusCheck
  class Parser
    attr_reader :xml

    def initialize(data)
      @data = data
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
      xml.locate("info/get_wait_list_size/*").first.to_i
    end

    def requests_in_app_queue
      xml.locate("info/supergroups/supergroup/group/get_wait_list_size/*").first.to_i
    end
  end
end
