require "rails_helper"

feature "user visits homepage" do
  scenario "they see a welcome and sign-in message" do
    visit root_path

    expect(find(".welcome")).to have_content("Welcome!")
    expect(find("#login")).to have_content("Log in with your Github account")
    within("#login") do
    expect(page).to have_link("Log in with your Github account")
    end
  end
end
