require 'spec_helper'
require_relative '../../lib/scheduler'

describe Scheduler do

    let(:schedule) { Scheduler::Schedule.new(meetings) }

    context "the Scheduler can be executed" do
        let(:meetings) {
            { meetings: [{
                name: 'Meeting 1',
                duration: 1.5,
                type: :onsite
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
            }]}
        }

        it { expect(Scheduler.run(schedule)).to be_instance_of Scheduler::Schedule }

    end

end
