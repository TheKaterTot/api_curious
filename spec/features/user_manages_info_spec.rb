require "rails_helper"

feature "user visits homepage" do
  scenario "they see a welcome and sign-in message" do
    visit root_path

    expect(find(".welcome")).to have_content("GitFake")
    expect(find("#login")).to have_content("Log in with your Github account")
    within("#login") do
    expect(page).to have_link("Log in with your Github account")
    end
  end
end

feature "user logs in with Github" do
  let(:user) { User.create(name: "Lee", username: "Lee100", uid: "4", token: "1234")}
  let(:brandon) { GithubUser.new("data" => {"login" => "brandon"}) }
  let(:jake) { GithubUser.new("data" => {"login" => "jake"}) }
  let(:jerrod) { GithubUser.new("data" => {"login" => "jerrod"}) }
  let(:repo_1) { GithubRepo.new("data" => {"name" => "repo_1"}) }
  let(:repo_2) { GithubFollowerRepo.new(jake, "data" => {"name" => "repo_2"}) }
  let(:organization) { GithubOrg.new( {"name" => "org"}) }
  let(:commit) do
    GithubCommit.new({
    "commit" => {
      "message" => "commit message",
        "committer" => {
          "date" => "2013-02-24T01:30:26Z"
        }
      }
    }, repo_1)
  end
  let(:follower_commit) do
    GithubFollowerCommit.new({
      "commit" => {
        "message" => "commit message",
        "committer" => {
          "date" => "2013-02-24T01:30:26Z"
        }
      }
    }, repo_2)
  end

  scenario "they visit the dashboard" do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
    allow(user).to receive(:starred_repos).and_return([repo_1])
    allow(user).to receive(:followers).and_return([jake, jerrod])
    allow(user).to receive(:following).and_return([brandon])
    allow(user).to receive(:recent_commits).and_return([commit])
    allow(user).to receive(:follower_commits).and_return([follower_commit])
    allow(user).to receive(:organizations).and_return([organization])

    visit dashboard_path
    within("#user_details") do
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.username)
      image = find("img")["src"]
      expect(image).to eq("https://avatars3.githubusercontent.com/u/#{user.uid}?v=3&s=150")
      expect(page).to have_content("Number of starred repos: 1")
      expect(page).to have_content("Number of followers: 2")
      expect(page).to have_content("Number of users you are following: 1")
    end
  end
end
