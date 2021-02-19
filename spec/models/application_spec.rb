require "rails_helper"
RSpec.describe Application, type: :model do
  describe "relationships" do
    it {should have_many :pet_applications}
    it {should have_many(:pets).through(:pet_applications)}
  end
  describe "instance methods" do
    it "can return status" do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet1 = shelter.pets.create!(sex: :female, name: "Fluffy", approximate_age: 3, description: 'super cute')
      app = Application.create!(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345')

      expect(app.status).to eq("In Progress")

      app.update(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345', description: 'i like pets')
      app.pets << pet1

      expect(app.status).to eq('pending')
    end
    it "can check complete" do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet1 = shelter.pets.create!(sex: :female, name: "Fluffy", approximate_age: 3, description: 'super cute')
      app = Application.create!(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345')

      expect(app.complete?).to eq(false)

      app.update(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345', description: 'i like pets')
      app.pets << pet1

      expect(app.complete?).to eq(true)
    end
    it "can check has pets" do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet1 = shelter.pets.create!(sex: :female, name: "Fluffy", approximate_age: 3, description: 'super cute')
      app = Application.create!(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345')

      expect(app.has_pets?).to eq(false)

      app.pets << pet1

      expect(app.has_pets?).to eq(true)
    end
  end
end
