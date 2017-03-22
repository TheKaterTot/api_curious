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

feature "user logs in with Github" do
  let(:user) { User.create(name: "Lee", username: "Lee100", uid: "4")}
  scenario "they visit the dashboard" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow(user).to receive(:starred_repos).and_return(2)
    allow(user).to receive(:followers).and_return(6)
    allow(user).to receive(:following).and_return(10)

    visit dashboard_path
    within("#user_details") do
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.username)
      image = find("img")["src"]
      expect(image).to eq("https://avatars3.githubusercontent.com/u/#{user.uid}?v=3&s=150")
      expect(page).to have_content(2)
      expect(page).to have_content(6)
      expect(page).to have_content(10)
    end
  end
end
