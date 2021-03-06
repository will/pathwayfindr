class RunsController < ApplicationController

  def index
    redirect_to :action => :new
  end

  def new
  end

  def create
    file = params[:file]
    unless file_is_good file
      flash[:warning] = "Upload failed. Please use a tab separated file and try again."
      redirect_to :action => :new and return 
    end
    
    run = Run.new
    run.file = params[:file]
    run.save
    
    run.process
    
    redirect_to run
  end

  def show
    @run = Run.find_by_id params[:id]
    redirect_to :action => :new and return unless @run
  end
  
  private
  
  def file_is_good(file)
    return false if file.blank?
    type = file.content_type
    return true if type == "application/octet-stream"
    return true if type =~ /text/
    false
  end
  
  def job_failed(job)
    (job.state == "finished" && job.exit_status != 0) || job.state == "dead"
  end
end

