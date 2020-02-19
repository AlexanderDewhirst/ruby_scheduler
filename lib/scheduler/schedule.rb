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

        private

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
