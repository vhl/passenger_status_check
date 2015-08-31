module PassengerStatusCheck
  module Checks
    class PassengerCheck
      OK, WARNING, CRITICAL, UNKNOWN = 0, 1, 2, 3

      def initialize(parser, thresholds)
        @parser = parser
        @thresholds = thresholds
      end

      def global_queue_check
        if @parser.requests_in_top_level_queue == @thresholds[:gqueue]
          OK
        else
          CRITICAL
        end
      end

      def app_queue_check
        if @parser.requests_in_app_queue == @thresholds[:aqueue]
          OK
        else
          CRITICAL
        end
      end

      def process_count_check
        if @thresholds[:pcount].include?(@parser.process_count)
          OK
        else
          CRITICAL
        end
      end
    end
  end
end

