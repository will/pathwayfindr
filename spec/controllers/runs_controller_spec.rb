require File.dirname(__FILE__) + '/../spec_helper'

describe RunsController do

describe "#index" do
  it "should redirect to new" do
    get 'index'
    response.should be_redirect
  end
end

describe "#show" do
  it "should find the run" do
    id = 1
    mock_run = mock "run", :id => id
    mock_job = mock "job", :tag => "#{id}", :exit_status => 0, :state => "finished"
    Run.should_receive(:find_by_id).with(id.to_s).and_return mock_run
    Bj.should_receive(:list).and_return [mock_job]
    get 'show', :id => 1
  end
end
end
