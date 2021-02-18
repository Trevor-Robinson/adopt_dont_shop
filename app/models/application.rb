class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true

  def status
    if !pets.empty? && description != nil
      'pending'
    else
      "In Progress"
    end  
  end
end
