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

require 'passenger_status_check/checks/passenger_check'

module PassengerStatusCheck
  module Formatters
    class CheckMk
      attr_reader :parser

      def initialize(parser, thresholds)
        @parser = parser
        @thresholds = thresholds
      end

      def passenger_check
        @passenger_check ||= PassengerStatusCheck::Checks::PassengerCheck.new(@parser, @thresholds)
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
        "#{passenger_check.global_queue_check} Global_queue count=#{requests} Global queue: #{requests}\n"
      end

      def application_queue
        requests = parser.requests_in_app_queue
        "#{passenger_check.app_queue_check} Application_queue count=#{requests} Application queue: #{requests}\n"
      end

      def passenger_processes
        process_count = parser.process_count
        "#{passenger_check.process_count_check} Passenger_processes count=#{process_count} Passenger processes: #{process_count}\n"
      end

      def process_data
        '0 Passenger_workers '.tap do |s|
          s << @parser.processes.map.with_index do |process, i|
            "p#{i}_cpu=#{process.cpu}|p#{i}_memory=#{process.memory}|" +
            "p#{i}_last_request_time=#{process.last_request_time}"
          end.join('|')
        end << " Passenger worker details\n"
      end
    end
  end
end
