class PetApplicationsController < ApplicationController
  def new
  end

  def create
      @pet_application = PetApplication.new(pet_applications_params)
      @pet_application.save
      redirect_to "/applications/#{@pet_application.application_id}"
  end

  def update
    pet_application = PetApplication.find_record(params[:pet_id], params[:application_id])
    pet_application.update(pet_applications_params)
    redirect_to "/admin/applications/#{pet_application.application_id}"
  end

  private
  def pet_applications_params
    params.permit(:application_id, :pet_id, :status)
  end
end
