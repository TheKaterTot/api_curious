require "rails_helper"

describe User do
  let(:user) { User.create(token: "12345abcde", username: "me") }
  let(:service) { double(:github_service) }

  before do
    allow(GithubService).to receive(:new)
      .with("12345abcde").and_return(service)
  end

  describe "#starred_repos" do
    let(:starred_repos) { ["1", "2"] }

    before do
      expect(service).to receive(:starred_repos).and_return(starred_repos)
    end

    it "returns starred repos from the github service" do
      expect(user.starred_repos).to eq(starred_repos)
    end
  end

  describe "#organizations" do
    let(:organizations) { ["supercool", "hardwork"] }

    before do
      expect(service).to receive(:organizations).and_return(organizations)
    end

    it "returns organizations from the github service" do
      expect(user.organizations).to eq(organizations)
    end
  end

  describe "#followers" do
    let(:followers) { ["jake", "fawn"] }

    before do
      expect(service).to receive(:followers).and_return(followers)
    end

    it "returns followers from the github service" do
      expect(user.followers).to eq(followers)
    end
  end

  describe "#following" do
    let(:following) { ["Han Solo"] }

    before do
      expect(service).to receive(:following).and_return(following)
    end

    it "returns users you are following from the github service" do
      expect(user.following).to eq(following)
    end
  end

  describe "#recent_commits" do
    let(:recent_commits) { ["commit_1", "commit_2"] }

    before do
      expect(service).to receive(:commits)
        .with("me")
        .and_return(recent_commits)
    end

    it "returns user's recent commits from the github service" do
      expect(user.recent_commits).to eq(recent_commits)
    end
  end

  describe "#follower_commits" do
    let(:follower_commits) { ["commit_1", "commit_2"] }
    let(:followers) { ["no_one"] }

    before do
      expect(service).to receive(:followers).and_return(followers)

      expect(service).to receive(:follower_commits)
        .with(followers)
        .and_return(follower_commits)
    end

    it "returns user's followers' commits from the github service" do
      expect(user.follower_commits).to eq(follower_commits)
    end
  end
end
