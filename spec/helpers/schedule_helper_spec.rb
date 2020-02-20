require 'spec_helper'
require_relative '../../helpers/schedule_helper'

describe ScheduleHelper do
    
    class TestClass
    end

    describe "#to_seconds" do
        let(:time) { 4 }
        let(:test_class) { TestClass.new }
        before do
            test_class.extend(ScheduleHelper)
        end

        context "should be a method" do
            it { expect(test_class.methods).to include(:to_seconds) }
        end

        context "should return a float" do
            it { expect(test_class.to_seconds(time)).to be_instance_of Float }
        end

        context "should convert hours to seconds" do
            it { expect(test_class.to_seconds(time)).to eq 14400.0 }
        end
    end

end