require_relative './meeting'

module Scheduler

    class Schedule
        # meetings
        # Offsite meeting buffer can extend past the end of the day
        # Case Bug: A day consisting of only offsite meetings that extends
        # from the beginning of the day to the end of the day without
        # any breaks would actually have a 9 hour length.
        DAY_LENGTH = {
            offsite: 8.5,
            onsite: 8
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
            meeting_str = meetings.reduce("") do |str, meeting| 
                str += meeting.start_time&.strftime("%I:%M %p") || 'none'
                str += ' - '
                str += meeting.end_time&.strftime("%I:%M %p") || 'none'
                str += ' - '
                str += meeting.name
                str += "\n"
            end
            meeting_str
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


        private

        # Get start time for first meeting
        def first_start_time
            time = Time.now
            Time.new(time.year, time.month, time.day, 9, 0, 0,  "-05:00")
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
            meeting.end_time + meeting.offsite_buffer
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
