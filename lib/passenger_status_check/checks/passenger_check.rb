# coding: utf-8
#
# Copyright © 2015 Vista Higher Learning, Inc.
#
# This file is part of passenger_status_check.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
