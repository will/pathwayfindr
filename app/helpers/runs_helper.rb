module RunsHelper
  def percent_done
    "%i" % (@run.percent_done.andand * 100) + "%"
  end
  
  def progress_bar
    %Q{<div class="prog-border"><div class="prog-bar" style="width:#{percent_done};"></div></div>}
  end
  
  def spinner
   "<img src='/images/roller.gif' />" if @job.state == "running"
  end
end
