require File.dirname(__FILE__) + '/../spec_helper'

describe AffyProbe do
  before(:each) do
    @affy_probe = AffyProbe.new
  end

  it "should be valid" do
    @affy_probe.should be_valid
  end
end
