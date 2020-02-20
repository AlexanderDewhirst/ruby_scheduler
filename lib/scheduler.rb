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
    MEETINGS = {
        example_1: [{
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
        }],
        example_2: [{
            name: 'Meeting 1',
            duration: 4,
            type: :offsite
        }, {
            name: 'Meeting 2',
            duration: 4,
            type: :offsite
        }],
        example_3: [{
            name: 'Meeting 1',
            duration: 0.5,
            type: :offsite
        }, {
            name: 'Meeting 2',
            duration: 0.5,
            type: :onsite
        }, {
            name: 'Meeting 3',
            duration: 2.5,
            type: :offsite
        }, {
            name: 'Meeting 4',
            duration: 3,
            type: :onsite
        }]
    }

    def self.run(meetings = nil)
        puts "Execute file"
        if meetings.nil?
            schedule = Scheduler::Schedule.new({
                meetings: MEETINGS[:example_1]
            })
        end

        schedule.reschedule
        return schedule
    end

end

schedule = Scheduler.run()
puts schedule
