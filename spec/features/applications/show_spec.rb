require 'rails_helper'

RSpec.describe 'Applications show page' do
  before :each do
    @shelter1 = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
    @shelter2 = Shelter.create!(name: "Silly Shelter", address: "123 Silly Ave", city: "Longmont", state: "CO", zip: 80012)
    @pet1 = @shelter1.pets.create!(image:"", name: "Hermes", description: "dog", approximate_age: 2, sex: "male")
    @pet2 = @shelter2.pets.create!(image:"", name: "Athena", description: "cat", approximate_age: 3, sex: "female")
  end
  it 'should show application details' do
    app = Application.create!(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345', description: "I like cats", status: "Pending")

    visit "applications/#{app.id}"

    expect(page).to have_content(app.name)
    expect(page).to have_content(app.street_address)
    expect(page).to have_content(app.city)
    expect(page).to have_content(app.state)
    expect(page).to have_content(app.zip_code)
    expect(page).to have_content(app.description)
    expect(page).to have_content(app.status)
  end

end
