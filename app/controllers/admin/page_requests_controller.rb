class Admin::PageRequestsController < ApplicationController
  def destroy
    @page_request = PageRequest.find(params[:id])
    @page_request_url = @page_request.url
    @page_request_count = @page_request.count_created
    if @page_request.destroy
      flash[:message] = "The page request #{@page_request_url} has been deleted. It had been requested #{@page_request_count} times."
      redirect_to dashboard_path
    end
  end
  
  def ignore
    @page_request = PageRequest.find(params[:id])
    @page_request.update_attribute(:ignore, true)
    redirect_to dashboard_path
  end
  
  def destroy_all
    PageRequest.destroy_all
    flash[:message] = "All page request records have been deleted. You've got a cleane slate!"
    redirect_to dashboard_path
  end
end