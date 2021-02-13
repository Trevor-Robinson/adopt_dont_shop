require "rails_helper"
RSpec.describe Application, type: :model do
  describe "relationships" do
    it {should have_many :pet_applications}
    it {should have_many(:pets).through(:pet_applications)}
  end
  describe "instance methods" do
    it "can return status" do
      app = Application.create!(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345', description: "I like cats")

      expect(app.status).to eq("Pending")
    end
  end
end
