# coding: utf-8
#
# Copyright © 2016 Vista Higher Learning, Inc.
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
    class BarmanCheck
      OK, WARNING, CRITICAL, UNKNOWN = 0, 1, 2, 3

      def initialize(parser, thresholds)
        @parser = parser
        @thresholds = thresholds
      end

      def backup_file_count_check
        num_backups = @parser.num_backups
        if num_backups >= @thresholds[:backup_count]
          OK
        elseif num_backups >= 1
          WARNING
        else CRITICAL
        end
      end

      def backup_age_check
        latest_bu_age = @parser.bu_age
        if latest_bu_age < @threshold[:bu_age]
          OK
        else
          CRITICAL
        end
      end

      def bad_status_check
        if @parser.bad_statuses.length == 0
          OK
        else
          CRITICAL
        end
      end
    end
  end
end
