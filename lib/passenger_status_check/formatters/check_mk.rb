module PassengerStatusCheck
  module Formatters
    class CheckMk
      attr_reader :parser

      def initialize(parser)
        @parser = parser
      end

      def output
        ''.tap do |s|
          s << global_queue
          s << application_queue
          s << passenger_processes
          s << process_data
        end
      end

      def global_queue
        requests = parser.requests_in_top_level_queue
        "# Global_queue count=#{requests} Global queue: #{requests}\n"
      end

      def application_queue
        requests = parser.requests_in_app_queue
        "# Application_queue count=#{requests} Application queue: #{requests}\n"
      end

      def passenger_processes
        process_count = parser.process_count
        "# Passenger_processes count=#{process_count} Passenger processes: #{process_count}\n"
      end

      def process_data
        ''.tap do |s|
          @parser.processes.each do |process|
            s << "# Passenger_#{process.pid} cpu=#{process.cpu}|memory=#{process.memory}|" +
                 "last_request_time=#{process.last_request_time} Passenger pid #{process.pid} " +
                 "cpu:#{process.cpu} memory:#{process.memory} last_request_time:#{process.last_request_time}\n"
          end
        end
      end
    end
  end
end
