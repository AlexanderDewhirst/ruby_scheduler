module Scheduler
    
    class Meeting
        # name, duration, type, start_time, end_time
        attr_reader   :name, :duration, :type
        attr_accessor :start_time, :end_time

        VALID_TYPES = [:offsite, :onsite]

        # Initialize Meeting object
        def initialize(params = {})
            @name = params.fetch(:name, nil)
            @duration = params.fetch(:duration, 0)
            @type = params.fetch(:type, nil)
            @start_time = params.fetch(:start_time, nil)
            @end_time = params.fetch(:end_time, nil)

            validate!
        end

        # Setter method for start_time attribute
        # Input:
        # - Time
        def set_start_time(start_time)
            @start_time = start_time
        end

        # Setter method for end_time attribute
        # Input:
        # - NONE
        def set_end_time
            @end_time = start_time + time_to_end
        end

        # Conditional method to check if type is offsite
        # Output:
        # - boolean
        def offsite?
            type == :offsite
        end

        # Calcuate offsite buffer for travel (30 minutes)
        # Output:
        # - Integer
        def offsite_buffer
            buffer = offsite? ? 0.5 : 0
            buffer * 3600
        end

        # Calculate duration of meeting
        # Output:
        # - Integer  / (Float)
        def time_to_end
            duration * 3600
        end

        private

        # Method to check valid parameters
        # Output:
        # - boolean
        def valid?
            @name.is_a? String
            @duration.is_a? (Integer || Float)
            @type.is_a? Symbol
            VALID_TYPES.include? @type
        end

        # Method to raise error if invalid parameters
        # Note: Would use RoR ActiveRecord validations if this were
        # a rails application. Could also use dry-rb gem validations 
        def validate!
            raise ArgumentError.new("Invalid Params") unless valid?
        end
    end

end
