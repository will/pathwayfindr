require File.dirname(__FILE__) + '/../spec_helper'

describe Run do
  before(:each) do
    @run = Run.new
  end
  
  it "#filename should give the path to run_(id number)" do
    @run.filename.should == "#{RAILS_ROOT}/tmp/run_#{@run.id}"
  end
  
  it "#filename= should set @temp_file" do
    @run.file = "yes"
    @run.instance_variable_get(:@temp_file).should == "yes"
  end
  
  it "should write the file after save" do
    @run.file = "yes"
    File.should_receive(:open).with(@run.filename, "w")
    @run.after_save
  end

  it "#store_groups should marshalize the data" do
    a = ["one", "two"]
    @run.store_groups a
    @run.groups.should == Marshal.dump(a)
  end
  
  it "#get_groups_and_colors should return the array with colors" do
    a = ["one", "two"]
    @run.store_groups a
    result = @run.get_groups_and_colors
    result[0][0].should == "one"
    result[0][1].should =~ /\#[A-F0-9]{6}/
    result[1][0].should == "two"
    result[1][1].should =~ /\#[A-F0-9]{6}/
  end
end
