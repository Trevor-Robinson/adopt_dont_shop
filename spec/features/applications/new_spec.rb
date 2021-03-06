require 'rails_helper'
RSpec.describe 'Applications new page' do
  it "can fill out and submit a new application" do
    visit 'applications/new'

    fill_in "name", with: 'Trevor'
    fill_in "address", with: '123 fake st.'
    fill_in "city", with: 'Denver'
    fill_in "state", with: 'CO'
    fill_in "zip_code", with: '12345'
    click_on "Submit Application"
    app = Application.last
    expect(current_path).to eq("/applications/#{app.id}")
    # save_and_open_page
    expect(page).to have_content(app.name)
    expect(page).to have_content(app.street_address)
    expect(page).to have_content(app.city)
    expect(page).to have_content(app.state)
    expect(page).to have_content(app.zip_code)
    expect(page).to have_content(app.description)
    expect(page).to have_content(app.status)
  end
  it "can return error if submitted without correct data" do
    visit 'applications/new'
    click_on "Submit Application"

    expect(current_path).to eq("/applications")
    expect(page).to have_content("Name can't be blank, Street address can't be blank, City can't be blank, State can't be blank, and Zip code can't be blank")
  end




end
