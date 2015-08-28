require 'ostruct'
require 'passenger_status_check/process'

module PassengerStatusCheck
  class Parser
    attr_reader :xml

    def initialize(file_path)
      @data = File.read(file_path)
    end

    def parse
      @xml = Ox.parse(@data)
    end

    # build_report returns an object with passenger status check stats
    # { requests_in_top_level_queue: 'abc',
    #   requests_in_queue: 'abc',
    #   processes: [{ memory: '123', cpu: '123', last_time_request_handled: '123'},
    #               { memory: '123', cpu: '123', last_time_request_handled: '123'}
    #              ]
    # }
    #

    def build_report
      report = OpenStruct.new()
      top_level_report_items = ['requests_in_top_level_queue', 'requests_in_queue']
      process_level_report_items = ['memory', 'cpu', 'last_time_request_handled']
      top_level_report_items.each do |item|
        # Call the method with the name of item
        # Assign the result to an oject key with the name of item
        report[item.to_s] = self.send(item)
      end

      # Create an array to hold process reporting
      report.processes = []

      report.processes = @xml.locate("info/supergroups/supergroup/group/processes/process/").map do |process_xml|
        Process.new(process_xml)
      end

      # process_list.each_with_index {|item, index|
      #   # For each process node, add a new object to the processes key of the report object
      #   report.processes.push(OpenStruct.new())

      #   # Add stats to the process object
      #   process_level_report_items.each do |process_item|
      #     # Call the method with the name of process_item
      #     # Assign the result to an oject key with the name of process_item
      #     # report.processes[index][process_item.to_s] =  self.send(process_item, item)
      #   end

      #   # I think I might like this simple code below better...
      #   # report.processes[index].memory = item.locate('rss/*').first
      #   # report.processes[index].cpu = item.locate('cpu/*').first
      #   # report.processes[index].last_time_request_handled = item.locate('last_used/*').first
      # }
      report
    end

    def process_count
      @xml.locate('info/supergroups/supergroup/group/processes/process').size
    end

    def requests_in_top_level_queue
      @xml.locate("info/get_wait_list_size/*").first
    end
    private :requests_in_top_level_queue

    def requests_in_queue
      @xml.locate("info/supergroups/supergroup/group/get_wait_list_size/*").first
    end
    private :requests_in_queue

  end

end
