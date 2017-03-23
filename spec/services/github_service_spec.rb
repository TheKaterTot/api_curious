require "rails_helper"

describe GithubService do
  let(:token) { ENV['ACCESS_TOKEN'] }
  let(:service) { GithubService.new(token) }
  let(:client) { double(:client) }
  let(:response) { double(:response, body: body) }
  let(:options) { Hash.new }
  let(:service) { GithubService.new(token, options) }

  describe "#starred_repos" do
    it "returns the starred repos" do
      VCR.use_cassette("github_service#starred_repos") do
        starred_repos = service.starred_repos
        expect(starred_repos.count).to eq(1)
      end
    end
  end

  describe "#followers" do
    let(:body) do
      [{"login" => "Carmer"},
       {"login" => "bob"},
       {"login" => "thekatertot"},
       {"login" => "bthesorceror"}].to_json
    end

    let(:options) { { client: client } }

    before do
      expect(client).to receive(:get)
        .with("/user/followers", { access_token: token })
        .and_return(response)
    end

    it "returns the user's followers" do
      followers = service.followers
      expect(followers.count).to eq(4)
      expect(followers.first).to be_a(GithubUser)
      expect(followers.first.name).to eq("Carmer")
    end
  end

  describe "#following" do
    it "returns the followed users" do
      VCR.use_cassette("github_service#following") do
        following = service.following
        expect(following.count).to eq(1)
        expect(following.first).to be_a(GithubUser)
        expect(following.first.name).to eq("bthesorceror")
      end
    end
  end

  describe "#repos" do
    let(:body) do
      [{"name" => "Hello, World"},
       {"name" => "Goodbye, World"}].to_json
    end

    let(:options) { { client: client } }

    before do
      expect(client).to receive(:get)
        .with("/user/repos", { access_token: token })
        .and_return(response)
    end

    it "returns the user's repos" do
      repos = service.repos
      expect(repos.count).to eq(2)
      expect(repos.first.name).to eq("Hello, World")
      expect(repos.first).to be_a(GithubRepo)
      expect(repos.last.name).to eq("Goodbye, World")
      expect(repos.last).to be_a(GithubRepo)
    end
  end

  describe "#organizations" do
    let(:body) do
      [{"login" => "cooltown"},
       {"login" => "superfreaks"}].to_json
    end

    let(:options) { {client: client} }

    before do
      expect(client).to receive(:get)
        .with("/user/orgs", { access_token: token })
        .and_return(response)
    end

    it "returns the user's orgs" do
      orgs = service.organizations
      expect(orgs.count).to eq(2)
      expect(orgs.first.name).to eq("cooltown")
      expect(orgs.first).to be_a(GithubOrg)
      expect(orgs.last.name).to eq("superfreaks")
      expect(orgs.last).to be_a(GithubOrg)
    end
  end

  describe "#commits" do
    let(:body) do
      [{"owner" => {"login" => "TheKaterTot"},
        "name" => "HelloWorld"},
       {"owner" => {"login" =>"bthesorceror"},
        "name" => "Xavier"}].to_json
    end

    let(:response_1) { double(:response, body: body_1) }
    let(:body_1) do
      [{"commit" => {"committer" => {"date" => "2013-02-24T01:30:26Z"}}},
       {"commit" => {"committer" => {"date" => "2013-01-24T01:30:26Z"}}}].to_json
    end

    let(:response_2) { double(:response, body: body_2) }
    let(:body_2) do
      [{"commit" => {"committer" => {"date" => "2013-04-24T01:30:26Z"}}},
       {"commit" => {"committer" => {"date" => "2013-03-24T01:30:26Z"}}}].to_json
    end

    let(:options) { { client: client } }

    before do
      expect(client).to receive(:get)
        .with("/user/repos", { access_token: token })
        .and_return(response)
      expect(client).to receive(:get)
        .with("/repos/TheKaterTot/HelloWorld/commits?author=TheKaterTot", { access_token: token })
        .and_return(response_1)
      expect(client).to receive(:get)
        .with("/repos/bthesorceror/Xavier/commits?author=TheKaterTot", { access_token: token })
        .and_return(response_2)
    end
    it "returns all commits for a user" do
      commits = service.commits("TheKaterTot")
      expect(commits.count).to eq(4)
      expect(commits.first.date.month).to eq(4)
      expect(commits.last.date.month).to eq(1)
    end
  end

  describe "#follower_commits" do
    let(:body) do
      [{"login" => "bthesorceror"},
       {"login" => "bob"}].to_json
    end

    let(:response_1) { double(:response, body: body_1) }
    let(:body_1) do
      [{"owner" => {"login" =>"bthesorceror"},
        "name" => "Xavier"}].to_json
    end

    let(:response_2) { double(:response, body: body_2) }
    let(:body_2) do
      [{"owner" => {"login" => "bob"},
        "name" => "School"}].to_json
    end

    let(:response_3) { double(:response, body: body_3) }
    let(:body_3) do
      [{"commit" => {"committer" => {"date" => "2013-06-24T01:30:26Z"}}},
       {"commit" => {"committer" => {"date" => "2013-05-24T01:30:26Z"}}}].to_json
    end

    let(:response_4) { double(:response, body: body_4) }
    let(:body_4) do
      [{"commit" => {"committer" => {"date" => "2013-04-24T01:30:26Z"}}},
       {"commit" => {"committer" => {"date" => "2013-03-24T01:30:26Z"}}}].to_json
    end

    let(:options) { { client: client } }

    before do
      expect(client).to receive(:get)
        .with("/user/followers", { access_token: token })
        .and_return(response)
      expect(client).to receive(:get)
        .with("/users/bthesorceror/repos", { access_token: token })
        .and_return(response_1)
      expect(client).to receive(:get)
        .with("/users/bob/repos", { access_token: token })
        .and_return(response_2)
      expect(client).to receive(:get)
        .with("/repos/bthesorceror/Xavier/commits?author=bthesorceror", { access_token: token })
        .and_return(response_3)
      expect(client).to receive(:get)
        .with("/repos/bob/School/commits?author=bob", { access_token: token })
        .and_return(response_4)
    end
    
    it "returns all recent commits from followers" do
      follower_commits = service.follower_commits(["bthesorceror", "bob"])
      expect(follower_commits.count).to eq(4)
      expect(follower_commits.first.date.month).to eq(6)
      expect(follower_commits.last.date.month).to eq(3)
    end
  end
end
