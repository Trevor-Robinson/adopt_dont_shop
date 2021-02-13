class ApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
  end

  private
  def applications_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :description, :status)
  end
end
