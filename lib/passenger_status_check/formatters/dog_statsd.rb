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

require_relative 'base'
require 'statsd'

module PassengerStatusCheck
  module Formatters
    class DogStatsd < Base

      def initialize(parser, thresholds, options)
        # Statsd instance should be created, if possible, once for the duration of the process
        @statsd = Statsd.new('localhost', 8125)
        super(parser, thresholds, options)
      end

      def output
        @statsd.batch do |stats|
         stats.gauge('passenger.global_queue.count', parser.requests_in_top_level_queue, tags: @options[:tags])
         stats.gauge('passenger.application_queue.count', parser.requests_in_app_queue, tags: @options[:tags])
         stats.gauge('passenger.processes.count', parser.process_count, tags: @options[:tags])
         parser.processes.map.with_index do |process, i|
           tags = @options[:tags] + ["process_id:#{i}"]
           stats.gauge("passenger.process.cpu", process.cpu, tags: tags)
           stats.gauge("passenger.process.memory", process.memory, tags: tags)
           stats.gauge("passenger.process.last_request_time", process.last_request_time, tags: tags)
         end
         status = passenger_check.resisting_deployment_check
         stats.service_check('passenger.resisting_deployment_status', status, message: "Passenger resisting deployment #{STATUS_LOOKUP[status]}")
        end
      end
    end
  end
end
