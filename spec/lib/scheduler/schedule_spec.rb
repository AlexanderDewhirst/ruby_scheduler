require 'spec_helper'
require_relative '../../../lib/scheduler/schedule'

describe Scheduler::Schedule do
    let(:meetings) {
        [{
            name: 'Meeting 1',
            duration: 2,
            type: :onsite
        }, {
            name: 'Meeting 2',
            duration: 1,
            type: :offsite
        }]
    }
    let(:params)    { { meetings: meetings } }

    let(:schedule)  { Scheduler::Schedule.new(params) }

    describe "#initialize" do
        context "should create Schedule object with valid params" do
            it { expect(schedule).to be_instance_of Scheduler::Schedule }
        end

        context.skip "should not create Schedule object with invalid params" do
            it { expect(Scheduler::Schedule.new(params)).to raise_error(ArgumentError) }
        end
    end

    describe "#to_s" do
        context "is valid method" do
            it { expect(schedule.methods).to include(:to_s) }
        end

        context "should return string" do
            it { expect(schedule.to_s).to be_instance_of String }
        end
    end

    describe "#reschedule" do
        context "reschedule meeting order and set start and end times" do
            it { expect(schedule.reschedule).to be_instance_of Array }
            it { expect(schedule.reschedule[0].name).to eq 'Meeting 2' }
        end
    end

end
    