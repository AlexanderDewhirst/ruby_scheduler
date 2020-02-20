module ScheduleHelper

    # Change hours to seconds for Time operations.
    # Input:
    # - Float
    # * This value represents a duration of time in hours
    # Output:
    # - float
    def to_seconds(time)
        time * 3600.0
    end

end
