require 'spec_helper'
require_relative '../../../lib/scheduler/meeting'

describe Scheduler::Meeting do
    let(:name)      { nil }
    let(:duration)  { nil }
    let(:type)      { nil }
    let(:params)    { { name: name, duration: duration, type: type } }

    let(:meeting)   { Scheduler::Meeting.new(params) }

    describe "#initialize" do
        context "should create Meeting object with valid params" do
            let(:name)      { 'Meeting 1' }
            let(:duration)  { 2 }
            let(:type)      { :offsite }

            it { expect(meeting).to be_instance_of Scheduler::Meeting }
        end

        # TODO: ArgumentError returned from private method validate!
        context.skip "should not create Meeting object with invalid params" do
            it { expect(Scheduler::Meeting.new(params)).to raise_error(ArgumentError) }
        end
    end

    describe "#set_start_time" do
        let(:name)      { 'Meeting 1' }
        let(:duration)  { 2 }
        let(:type)      { :offsite }

        context "is accessible method" do
            it { expect(meeting.methods).to include(:set_start_time) }
        end

        context "should set meeting start_time with valid Time" do
            before do
                @time = Time.now
            end

            it { expect(meeting.set_start_time(@time)).to_not be_nil }
            it { expect(meeting.set_start_time(@time)).to be_instance_of Time }
        end
    end

    describe "#set_end_time" do
        let(:name)      { 'Meeting 1' }
        let(:duration)  { 2 }
        let(:type)      { :offsite }
        
        context "is valid method" do
            it { expect(meeting.methods).to include(:set_end_time) }
        end

        context "should return if no meeting start_time" do
            it { expect(meeting.set_end_time).to be_nil }
        end

        context "should set meeting end_time if meeting has start_time" do
            before do
                time = Time.now
                meeting.set_start_time(time)
            end

            it { expect(meeting.set_end_time).to_not be_nil }
            it { expect(meeting.set_end_time).to be_instance_of Time }
        end
    end

    describe "#offsite?" do
        let(:name)      { 'Meeting 1' }
        let(:duration)  { 2 }
        let(:type)      { :offsite }

        context "is valid method" do
            it { expect(meeting.methods).to include(:offsite?) }
        end

        context "meeting is of type offsite" do
            it { expect(meeting.offsite?).to be_truthy }
        end

        context "meeting is of type :onsite" do
            let(:type)  { :onsite }

            it { expect(meeting.offsite?).to be_falsy }
        end
    end

    describe "#offsite_buffer" do
        let(:name)      { 'Meeting 1' }
        let(:duration)  { 2 }
        let(:type)      { :offsite }

        context "should return buffer for an offsite meeting" do
            before do
                meeting.stub(:offsite?).and_return(TRUE)
            end

            it { expect(meeting.offsite_buffer).to be_instance_of Float }
            it { expect(meeting.offsite_buffer).to eq 0.5 }
        end

        context "should return buffer for an onsite meeting" do
            before do
                meeting.stub(:offsite?).and_return(FALSE)
            end

            it { expect(meeting.offsite_buffer).to be_instance_of Float }
            it { expect(meeting.offsite_buffer).to eq 0 }
        end
    end

end
