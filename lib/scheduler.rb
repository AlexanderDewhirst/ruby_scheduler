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
    def self.run(schedule = nil)
        puts "Execute file"
        if schedule.nil?
            schedule = Scheduler::Schedule.new({
                meetings: [{
                    name: 'Meeting 1',
                    duration: 1.5,
                    type: :onsite,
                }, {
                    name: 'Meeting 2',
                    duration: 2,
                    type: :offsite
                }, {
                    name: 'Meeting 3',
                    duration: 1,
                    type: :onsite
                }, {
                    name: 'Meeting 4',
                    duration: 1,
                    type: :offsite
                }, {
                    name: 'Meeting 5',
                    duration: 1,
                    type: :offsite
                }]
            })
        end

        puts schedule
    end

end

Scheduler.run()
