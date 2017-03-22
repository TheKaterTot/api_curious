require "rails_helper"

describe GithubService do
  let(:token) { ENV['ACCESS_TOKEN'] }
  let(:service) { GithubService.new(token) }

  describe "#starred_repos" do
    it "returns the starred repos" do
      VCR.use_cassette("github_service#starred_repos") do
        starred_repos = service.starred_repos
        expect(starred_repos.count).to eq(1)
      end
    end
  end

  describe "#followers" do
    it "returns the user's followers" do
      VCR.use_cassette("github_service#followers") do
        followers = service.followers
        expect(followers.count).to eq(4)
        expect(followers.first).to be_a(GithubUser)
      end
    end
  end

  describe "#following" do
    it "returns the followed users" do
      VCR.use_cassette("github_service#following") do
        following = service.following
        expect(following.count).to eq(1)
        expect(following.first).to be_a(GithubUser)
      end
    end
  end
end
