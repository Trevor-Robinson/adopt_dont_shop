class Application < ApplicationRecord
  has_many :pet_applications, dependent: :destroy
  has_many :pets, through: :pet_applications
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true

  def status
    if pet_applications.where(status: nil).length == 0  && pet_applications.where(status: true) == pet_applications && !pets.empty? && description != nil
      'Approved'
    elsif pet_applications.where(status: nil).length == 0 && pet_applications.where(status: false).length > 0 && !pets.empty? && description != nil
      'Rejected'
    elsif !pets.empty? && description != nil
      'pending'
    else
      "In Progress"
    end
  end

  def complete?
    !pets.empty? && description != nil
  end

  def has_pets?
    !pets.empty?
  end
end
