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

      def initialize(parser, thresholds)
        # Statsd instance should be created, if possible, once for the duration of the process
        @statsd = Statsd.new('localhost', 8125)
        super(parser, thresholds)
      end

      def output
        @statsd.batch do |stats|
         stats.histogram('passenger.global_queue.count', parser.requests_in_top_level_queue, tags: tags)
         stats.histogram('passenger.application_queue.count', parser.requests_in_app_queue, tags: tags)
         stats.histogram('passenger.processes.count', parser.process_count, tags: tags)
         parser.processes.map.with_index do |process, i|
           stats.histogram("passenger.process_#{i}.cpu", process.cpu, tags: tags)
           stats.histogram("passenger.process_#{i}.memory", process.memory, tags: tags)
           stats.histogram("passenger.process_#{i}.last_request_time", process.last_request_time, tags: tags)
         end
         status = passenger_check.resisting_deployment_check
         stats.event('passenger.resisting_deployment_status', STATUS_LOOKUP[status], tags: tags)
        end
      end

      def tags
        # Currently it has not been defined how the tags on Datadog will be setup.
        ['testing', 'to_be_defined']
      end
      private :tags
    end
  end
end
