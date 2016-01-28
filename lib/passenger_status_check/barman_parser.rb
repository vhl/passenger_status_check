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

require 'ostruct'

module PassengerStatusCheck
  class BarmanParser
    attr_reader :db_name, :latest_bu_age, 
                :num_backups, :bad_statuses

    def initialize(db_check_data, db_backup_list_data)
      @db_check_data[] = db_check_data # my parsing method assumed lines in a file but what will I be getting from Barman?
      @db_backups_data[] = db_backup_list_data
      # should parsing happen now?
      parse_check_data
      parse_backup_list_data
    end

    def parse_check_data
      server_info = @db_check_data.first
      @db_name, rest_of_line = server_info.split(":")  
      @bad_statuses = []
      # store anything that reports as failed in the bad status array
      server_info[1..-1].each do |status_line| 
        feature, status, part1, part2 = status_line.split(":")
        if status !~ /OK/
          @bad_statuses.push(feature.strip)
        end
      end 
    end
    
    def parse_backup_list_data
      if @db_backups_data.length == 0
        @num_backups = 0
      else # process the backup list
        @backups = @db_backups_data.map do |bu_line| 
          bu_line.split(/(?:^|\W)Size(?:$|\W)*(\d+.\.\d+)/)[1].to_f
        end
        @num_backups = @backups.length
      end
    end
    
    # determine age in hours of the most recent backup
    # still figuring out when this will be called. as it 
    # stands the number of backups mist have been determined before we
    # call this. also figure out if this returns the latest_backup_age
    # or just fills it
    def determine_backup_age
    # no need to do anything if there are no backups; 
    # also assumes num_backups has been calculated first
      if num_backups > 1
        name, datetime_recent_file_string, throw_away = @db_backups_data.first.split("-")
        datetime_most_recent = DateTime.parse(datetime_recent_file_string)
        now = DateTime.now
        # figure out how old the latest backup is in hours
        @latest_bu_age = ((now.to_time - datetime_most_recent.to_time)/60/60).round
      end
    end
    
    def backups_growing
      last_size = 0.0
      backups_growing = true
      @backups.reverse_each do |backup|
        if last_size > backup
          backups_growing = false
        end
        last_size = backup
      end
      return backups_growing
    end
  end
end
