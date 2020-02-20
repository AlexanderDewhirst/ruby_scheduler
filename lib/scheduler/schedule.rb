# RoR configuration would autoload the lib and helpers directories
require_relative '../helpers/schedule_helper'
require_relative './meeting'

module Scheduler

    class Schedule
        # meetings
        include ScheduleHelper
        # Offsite meeting buffer can extend past the end of the day
        # Case Bug: A day consisting of only offsite meetings that extends
        # from the beginning of the day to the end of the day without
        # any breaks would actually have a 9 hour length.
        # Case Bug UPDATE: Check valid meeting schedule works. 
        DAY_LENGTH = {
            all_offsite: 9,
            any_offsite: 8.5,
            no_offsite: 8
        }

        attr_accessor :meetings

        # Initialize a Schedule of Meeting objects.
        def initialize(params = {})
            @meetings = []
            meetings_arr = params.fetch(:meetings, nil)
            meetings_arr.each do |meeting|
                meeting_object = Meeting.new(meeting)
                @meetings << meeting_object
            end

            validate!
        end

        # Override `to_s` method to print expected message provided in README.
        # Output:
        # - String
        def to_s
            valid = valid_meeting_schedule? ? "Valid Schedule\n" : "Invalid Schedule\n"
            meeting_str = meetings.reduce(valid) do |str, meeting| 
                str += meeting.start_time&.strftime("%I:%M %p") || 'none'
                str += ' - '
                str += meeting.end_time&.strftime("%I:%M %p") || 'none'
                str += ' - '
                str += meeting.name
                str += "\n"
            end
            meeting_str
        end

        # Check if any time left after meetings
        # Output:
        # - boolean
        def valid_meeting_schedule?
            time_left_in_day >= 0
        end

        # Check if all meetings are offsite
        # Note: If RoR application, I would use the ActiveRecord scope method
        # Output:
        # - boolean
        def all_offsite_meetings?
            meetings.all? { |meeting| meeting.offsite? }
        end

        # Check if any meetings are offsite
        # Note: If RoR application, I would use the ActiveRecord scope method
        # Output:
        # - boolean
        def any_offsite_meetings?
            meetings.any? { |meeting| meeting.offsite? }
        end


        # Set a meeting schedule using an optimal meeting order
        # Note: Would consider using Trailblazer to construct
        # a contract and operation.
        def reschedule
            set_meeting_order

            meetings.first.set_start_time(first_start_time)

            meetings.each_with_index do |meeting, index|
                if meeting.start_time.nil?
                    previous_meeting = meetings[index - 1]
                    next_start_time = next_start_time(previous_meeting)
                    meeting.set_start_time(next_start_time)
                end
                meeting.set_end_time
            end
            @meetings = meetings
            self
        end

        # Calculate total meeting time for both onsite and offsite meetings
        def total_meeting_time
            calculate_total_duration(offsite_meetings, offsite: true) + calculate_total_duration(onsite_meetings, offsite: false)
        end

        private

        # Get start time for first meeting
        def first_start_time
            time = Time.now
            Time.new(time.year, time.month, time.day, 9, 0, 0,  "-05:00")
        end

        # Determine total time in day given whether or not
        # there consist any offsite meetings. 
        # Note: See BUG in class constant declaration.
        def time_left_in_day
            if all_offsite_meetings?
                day_length = DAY_LENGTH[:all_offsite]
            elsif any_offsite_meetings?
                day_length = DAY_LENGTH[:any_offsite]
            else
                day_length = DAY_LENGTH[:no_offsite]
            end
            day_length - total_meeting_time
        end

        # Place offsite before onsite meetings for an
        # optimal meeting order
        def optimal_meeting_order
            offsite_meetings + onsite_meetings
        end

        # Select offsite meetings from all meetings
        # Output:
        # - Array
        def offsite_meetings
            meetings.select { |meeting| meeting.offsite? }
        end

        # Select onsite meetings from all meetings
        # Output:
        # - Array
        def onsite_meetings
            meetings.select{ |meeting| !meeting.offsite? }
        end

        # Set an optimal meeting order
        def set_meeting_order
            @meetings = optimal_meeting_order
        end

        # Calculate next meeting start_time
        def next_start_time(meeting)
            meeting.end_time + to_seconds(meeting.offsite_buffer)
        end

        # Calculate total meeting time and buffer for selected meetings
        # Note: This does not use the same methods as reschedule - refactor
        # to reuse those methods for consistency
        def calculate_total_duration(selected_meetings, offsite:)
            start_buffer = offsite ? 0.5 : 0
            selected_meetings.reduce(start_buffer) { |sum, meeting| offsite ? sum + (meeting.duration + 0.5) : sum + meeting.duration }
        end

        # Method to check valid parameters
        # Output:
        # - boolean
        def valid?
            meetings.is_a? Array
        end

        # Method to raise error if invalid parameters
        # Note: Would use RoR ActiveRecord validations if this were
        # a rails application. Could also use dry-rb gem validations 
        def validate!
            raise ArgumentError.new("Invalid Params") unless valid?
        end

    end
end
