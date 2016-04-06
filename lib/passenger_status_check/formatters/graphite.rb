require 'passenger_status_check/checks/passenger_check'

module PassengerStatusCheck
  module Formatters
    class Graphite
      attr_reader :parser

      def initialize(parser, thresholds)
        @parser = parser
        @thresholds = thresholds
      end

      def passenger_check
        @passenger_check ||= PassengerStatusCheck::Checks::PassengerCheck.new(@parser, @thresholds)
      end

      def output
        # TODO: define the behavior for graphite export
        global_queue
      end

      def now
        Time.now.to_i
      end

      def global_queue
        "passenger.global.queue.count #{global_queue_requests} #{now}"
      end

      def application_queue
        "passenger.application.queue.count #{application_queue_requests} #{now}"
      end

      def passenger_processes
        "passenger.processes.count #{process_count} #{now}"
      end

      def global_queue_requests
        parser.requests_in_top_level_queue
      end

      def application_queue_requests
        parser.requests_in_app_queue
      end

      def process_count
        parser.process_count
      end

      def process_data
        processes = []
        @parser.processes.each do |process|
          processes << {
            pid: process.pid,
            cpu: process.cpu,
            memory: process.memory,
            last_request_time: process.last_request_time
          }
        end
        processes
      end
    end
  end
end
