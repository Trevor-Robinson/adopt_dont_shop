require 'rails_helper'

RSpec.describe 'Applications admin page' do
  before :each do
    @shelter1 = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
    @shelter2 = Shelter.create!(name: "Silly Shelter", address: "123 Silly Ave", city: "Longmont", state: "CO", zip: 80012)
    @pet1 = @shelter1.pets.create!(image:"", name: "Hermes", description: "dog", approximate_age: 2, sex: "male")
    @pet2 = @shelter2.pets.create!(image:"", name: "Athena", description: "cat", approximate_age: 3, sex: "female")
    @app = Application.create!(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345')
    @app.pets << @pet1
    @app.pets << @pet2
  end
  it 'should show application details' do
    visit "admin/applications/#{@app.id}"

    expect(page).to have_content(@app.name)
    expect(page).to have_content(@app.street_address)
    expect(page).to have_content(@app.city)
    expect(page).to have_content(@app.state)
    expect(page).to have_content(@app.zip_code)
    expect(page).to have_content(@app.status)
    expect(page).to have_content("Pets to Adopt:")
  end

  it 'should show pet details' do
    visit "admin/applications/#{@app.id}"
    expect(page).to have_content(@pet1.name)
    expect(page).to have_content(@pet1.approximate_age)
    expect(page).to have_content(@pet1.sex)
    expect(page).to have_content(@pet1.shelter.name)
    expect(page).to have_content(@pet2.name)
    expect(page).to have_content(@pet2.approximate_age)
    expect(page).to have_content(@pet2.sex)
    expect(page).to have_content(@pet2.shelter.name)
  end

  it 'should have approve and reject buttons for each pet on app' do
    visit "admin/applications/#{@app.id}"
    within(".pet-#{@pet1.id}") do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
    within(".pet-#{@pet2.id}") do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end

  it 'can interact with approve button' do
    visit "admin/applications/#{@app.id}"
    within(".pet-#{@pet1.id}") do
      click_on "Approve"
      expect(page).to have_content("Approved")
      expect(page).to have_button("Reject")
    end
  end
  it 'can interact with reject button' do
    visit "admin/applications/#{@app.id}"
    within(".pet-#{@pet1.id}") do
      click_on "Reject"
      expect(page).to have_content("Rejected")
    end
  end
  it 'can reject after accepting' do
    visit "admin/applications/#{@app.id}"
    within(".pet-#{@pet1.id}") do
      click_on "Approve"
      expect(page).to have_content("Approved")
      expect(page).to have_button("Reject")
      click_on "Reject"
      expect(page).to have_content("Rejected")
    end
  end
  it 'can reject after accepting' do
    visit "admin/applications/#{@app.id}"
    within(".pet-#{@pet1.id}") do
      click_on "Approve"
      expect(page).to have_content("Approved")
      expect(page).to have_button("Reject")
      click_on "Reject"
      expect(page).to have_content("Rejected")
    end
  end

  it 'can accept and reject without effecting other apps' do
    app2 = Application.create!(name: "Test", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345')
    app2.pets << @pet1
    visit "admin/applications/#{@app.id}"
    within(".pet-#{@pet1.id}") do
      click_on "Approve"
      expect(page).to have_content("Approved")
      expect(page).to have_button("Reject")
    end
    visit "/admin/applications/#{app2.id}"
    within(".pet-#{@pet1.id}") do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
    visit "/admin/applications/#{@app.id}"
    within(".pet-#{@pet1.id}") do
      expect(page).to have_content("Approved")
      expect(page).to have_button("Reject")
      click_on "Reject"
      expect(page).to have_content("Rejected")
    end
    visit "/admin/applications/#{app2.id}"
    within(".pet-#{@pet1.id}") do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end
  it 'can show correct status' do
    @app.update(name: "Trevor", street_address: "123 Fake St.", city: "Denver", state: "CO", zip_code: '12345', description: "I like pets")
    visit "admin/applications/#{@app.id}"
    expect(page).to have_content("pending")
    within(".pet-#{@pet1.id}") do
      click_on "Approve"
    end
    within(".pet-#{@pet2.id}") do
      click_on "Approve"
    end
    expect(page).to have_content("Approved")
    within(".pet-#{@pet2.id}") do
      click_on "Reject"
    end
    expect(page).to have_content("Rejected")
  end
end
