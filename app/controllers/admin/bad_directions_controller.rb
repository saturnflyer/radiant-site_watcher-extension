class Admin::BadDirectionsController < ApplicationController
  def destroy
    @bad_direction = BadDirection.find(params[:id])
    @bad_referrer = @bad_direction.bad_referrer
    if @bad_direction.destroy
      if @bad_referrer.bad_directions.count == 0
        @bad_referrer.destroy
      end
      flash[:message] = "The bad direction from #{@bad_referrer.url} has been deleted."
      redirect_to dashboard_path
    end
  end
end