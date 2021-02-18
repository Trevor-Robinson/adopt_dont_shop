require 'rails_helper'

RSpec.describe 'Applications show page' do
  before :each do
    @shelter1 = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
    @shelter2 = Shelter.create!(name: "Silly Shelter", address: "123 Silly Ave", city: "Longmont", state: "CO", zip: 80012)
    @pet1 = @shelter1.pets.create!(image:"", name: "Hermes", description: "dog", approximate_age: 2, sex: "male")
    @pet2 = @shelter2.pets.create!(image:"", name: "Athena", description: "cat", approximate_age: 3, sex: "female")
  end
  it 'should show application details' do
    app = Application.create!(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345')

    visit "applications/#{app.id}"

    expect(page).to have_content(app.name)
    expect(page).to have_content(app.street_address)
    expect(page).to have_content(app.city)
    expect(page).to have_content(app.state)
    expect(page).to have_content(app.zip_code)
    expect(page).to have_content(app.status)
    expect(page).to have_content("Pets to Adopt:")
  end
  it 'should let user search for pets' do
      app = Application.create!(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345')
      visit "applications/#{app.id}"

      expect(page).to have_content("Add a Pet to this Application")
      expect(page).to have_field("query")

      fill_in "query", with: 'Hermes'

      click_on 'Search'

      expect(page).to have_content(@pet1.name)
  end
  it 'should let users add pets' do
    app = Application.create!(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345')
    visit "applications/#{app.id}"
    fill_in "query", with: 'Hermes'

    click_on 'Search'
    click_on 'Adopt this Pet'
    within('.to_adopt') do
      expect(page).to have_content(@pet1.name)
    end
  end
  it 'can add reason for pet ownership and submit after adding pet' do
    app = Application.create!(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345', status: "In Progress")
    visit "applications/#{app.id}"
    expect(page).to_not have_field(:description)
    expect(page).to_not have_button("Submit Application")
    fill_in "query", with: 'Hermes'

    click_on 'Search'
    expect(page).to_not have_field(:description)
    expect(page).to_not have_button("Submit Application")
    click_on 'Adopt this Pet'

    expect(page).to have_field(:description)
    expect(page).to have_button("Submit Application")

    fill_in "description", with: "I like pets"
    click_on "Submit Application"
    save_and_open_page
    expect(current_path).to eq("/applications/#{app.id}")
    expect(page).to_not have_field(:description)
    expect(page).to_not have_button("Submit Application")
    expect(page).to_not have_field(":query")
    expect(page).to_not have_button("Adopt this Pet")
    expect(page).to_not have_button("Search")

    expect(page).to have_content(app.name)
    expect(page).to have_content(app.street_address)
    expect(page).to have_content(app.city)
    expect(page).to have_content(app.state)
    expect(page).to have_content(app.zip_code)
    expect(page).to have_content('pending')
    expect(page).to have_content("Pets to Adopt:")
    expect(page).to have_content(@pet1.name)
    expect(page).to have_content(@pet1.approximate_age)
    expect(page).to have_content(@pet1.sex)
    expect(page).to have_content(@pet1.shelter.name)
    expect(page).to have_content("Why would you make a good owner for these pets?")
    expect(page).to have_content(app.description)
  end

end
