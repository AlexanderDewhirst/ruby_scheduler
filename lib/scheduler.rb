require_relative './scheduler/schedule.rb'
require_relative './scheduler/meeting.rb'

module Scheduler

    # This module should execute the project task.
    # Given a schedule, ptimize the meetings, to 
    # fit them within a business day.
    # Input:
    # - Schedule object
    # Output:
    # - String
    def self.run
    end

end

Scheduler.run()
