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

require 'passenger_status_check/checks/barman_check'

module PassengerStatusCheck
  module Formatters
    class BarmanCheckMk
      attr_reader :parser

      def initialize(parser, thresholds)
        @parser = parser
        @thresholds = thresholds
      end

      def barman_check
        @barman_check ||= PassengerStatusCheck::Checks::BarmanCheck.new(@parser, @thresholds)
      end

      def output
        ''.tap do |s|
          s << backup_status
          s << backup_growth
        end
      end

      def backup_status
        # initial stab - direct report not checking for unhappy paths
        num_backups = parser.num_backups
        "#{barman_check.bad_status_check} Barman_#{parser.server_name}_status - OK backups=#{parser.num_backups} backup_age=#{parser.latest_backup}\n"
      end
      
      def backup_growth
        # initial stab - direct report not checking for unhappy paths
        num_backups = parser.num_backups
        "#{barman_check.backup_age_check} Barman_#{parser.server_name}_growth - OK\n"
      end


    end
  end
end
