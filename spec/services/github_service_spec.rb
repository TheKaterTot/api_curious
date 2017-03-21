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
end
