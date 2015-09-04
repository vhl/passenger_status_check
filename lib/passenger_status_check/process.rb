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
  class Process
    def initialize(process_xml)
      @process_xml = process_xml
    end

    def pid
      @process_xml.locate('pid/*').first
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
