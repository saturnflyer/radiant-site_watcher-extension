class Admin::NotFoundRequestsController < ApplicationController
  def destroy
    @not_found_request = NotFoundRequest.find(params[:id])
    @page_request_url = @page_request.url
    @page_request_count = @page_request.count_created
    if @not_found_request.destroy
      flash[:message] = "The page request #{@page_request_url} has been deleted. It had been requested #{@page_request_count} times."
      redirect_to dashboard_path
    end
  end
end