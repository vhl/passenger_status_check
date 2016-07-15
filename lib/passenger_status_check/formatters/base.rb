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
    class Base
      attr_reader :parser
      STATUS_LOOKUP = { 0 => 'OK', 1 => 'WARNING', 2 => 'CRITICAL', 3 => 'UNKNOWN' }.freeze

      def initialize(parser, thresholds, options = {})
        @parser = parser
        @thresholds = thresholds
        @options = options
      end

      def passenger_check
        @passenger_check ||= PassengerStatusCheck::Checks::PassengerCheck.new(@parser, @thresholds)
      end

      def output
        raise 'output must be defined on the concrete classes.'
      end
    end
  end
end
