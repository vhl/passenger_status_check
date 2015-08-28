module PassengerStatusCheck
  class Process
    def initialize(process_xml)
      @process_xml = process_xml
    end

    def memory
      @process_xml.locate('rss/*').first
    end

    def cpu
      @process_xml.locate('cpu/*').first
    end

    def last_request_time
      @process_xml.locate('last_used/*').first
    end

  end
end
