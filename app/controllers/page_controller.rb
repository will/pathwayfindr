class PageController < ApplicationController

  verify :params => :name, :only => :show, :redirect_to => :root_url
  before_filter :ensure_valid, :only => :show

  def show
    render :template => "pages/#{current_page}"
  end

  protected

  def current_page
    params[:name].to_s.downcase
  end

  def ensure_valid
    unless %w(about copyright guidelines help privacy terms).include? current_page
      render :nothing => true, :status => 404 and return false
    end
  end

end