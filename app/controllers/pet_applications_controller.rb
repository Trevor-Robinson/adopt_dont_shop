class PetApplicationsController < ApplicationController
  def new
    @pet_application = Application.new
  end

  def create
      @pet_application = PetApplication.new(pet_applications_params)
      @pet_application.save
      redirect_to "/applications/#{@pet_application.application_id}"
  end

  private
  def pet_applications_params
    params.permit(:application_id, :pet_id)
  end
end
