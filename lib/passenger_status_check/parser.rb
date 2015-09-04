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
