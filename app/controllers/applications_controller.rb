class ApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
  end

  def new
  end

  def create
      @application = Application.create(applications_params)
      redirect_to "/applications/#{@application.id}"
  end

  private
  def applications_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :description, :status)
  end
end
