require File.dirname(__FILE__) + '/../spec_helper'

describe RunsHelper do
  
  #Delete this example and add some real ones or delete this file
  it "#spinner should only return something if the job is running" do
    @job = mock "spinner", :state => "running"
    spinner.should_not be_nil
    
    @job = mock "spinner", :state => "finished"
    spinner.should be_nil
  end
  
  
end
