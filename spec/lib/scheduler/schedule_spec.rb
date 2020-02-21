require 'spec_helper'
require_relative '../../../lib/ruby/scheduler/schedule'

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
            it { expect(schedule.reschedule).to be_instance_of Scheduler::Schedule }
            it { expect(schedule.reschedule.meetings[0].name).to eq 'Meeting 2' }
        end
    end

    describe "#valid_meeting_schedule?" do
        context "when time_left_in_day is greater than 0" do
            before do
                schedule.stub(:time_left_in_day).and_return(0.5)
            end

            it { expect(schedule.valid_meeting_schedule?).to be_truthy }
        end

        context "when time_left_in_day equals 0" do
            before do
                schedule.stub(:time_left_in_day).and_return(0.0)
            end

            it { expect(schedule.valid_meeting_schedule?).to be_truthy }
        end

        context "when time_left_in_day is less than 0" do
            before do
                schedule.stub(:time_left_in_day).and_return(-1.0)
            end

            it { expect(schedule.valid_meeting_schedule?).to be_falsy }
        end

    end

    describe "#all_offsite_meetings?" do
        context "when all meetings are offsite" do
            let(:meetings) {
                [{
                    name: 'Meeting 1',
                    duration: 2,
                    type: :offsite
                }, {
                    name: 'Meeting 2',
                    duration: 1,
                    type: :offsite
                }]
            }

            it { expect(schedule.all_offsite_meetings?).to be_truthy }
        end

        context "when any meetings are offsite" do
            it { expect(schedule.all_offsite_meetings?).to be_falsy }
        end

        context "when no meetings are offsite" do
            let(:meetings) {
                [{
                    name: 'Meeting 1',
                    duration: 2,
                    type: :onsite
                }, {
                    name: 'Meeting 2',
                    duration: 1,
                    type: :onsite
                }]
            }

            it { expect(schedule.all_offsite_meetings?).to be_falsy }
        end
    end

    describe "#any_offsite_meetings?" do
        context "when all meetings are offsite" do
            let(:meetings) {
                [{
                    name: 'Meeting 1',
                    duration: 2,
                    type: :offsite
                }, {
                    name: 'Meeting 2',
                    duration: 1,
                    type: :offsite
                }]
            }

            it { expect(schedule.any_offsite_meetings?).to be_truthy }
        end

        context "when any meetings are offsite" do
            it { expect(schedule.any_offsite_meetings?).to be_truthy }
        end

        context "when no meetings are offsite" do
            let(:meetings) {
                [{
                    name: 'Meeting 1',
                    duration: 2,
                    type: :onsite
                }, {
                    name: 'Meeting 2',
                    duration: 1,
                    type: :onsite
                }]
            }

            it { expect(schedule.any_offsite_meetings?).to be_falsy }
        end
    end

    describe "#total_meeting_time" do
        context "should return a float value representing hours" do
            it { expect(schedule.total_meeting_time).to be_instance_of Float }
            it { expect(schedule.total_meeting_time).to eq 4.0 }
        end
    end

end
    