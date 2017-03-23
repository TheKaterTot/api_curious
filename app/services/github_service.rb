class GithubService
  attr_reader :token, :client

  def initialize(token, options={})
    @token = token
    @client = options.fetch(:client) do
      Faraday.new(url: "https://api.github.com")
    end
  end

  def starred_repos
    fetch_data("/user/starred").map do |repo|
      GithubStarredRepo.new(repo)
    end
  end

  def repos
    fetch_data("/user/repos").map do |repo|
      GithubRepo.new(repo)
    end
  end

  def organizations
    fetch_data("/user/orgs").map do |org|
      GithubOrg.new(org)
    end
  end

  def followers
    fetch_data("/user/followers").map do |follower|
      GithubUser.new(follower)
    end
  end

  def follower_repos
    followers.map do |follower|
      fetch_data("/users/#{follower.name}/repos").map do |repo|
        GithubFollowerRepo.new(follower, repo)
      end
    end.flatten
  end

  def following
    fetch_data("/user/following").map do |user|
      GithubUser.new(user)
    end
  end

  def commits(user)
    repos.map do |repo|
      fetch_data("#{repo.commit_url}?author=#{user}").map do |commit|
        if commit.is_a?(Hash)
          GithubCommit.new(commit, repo)
        end
      end
    end.flatten.sort_by { |commit| commit.date }.reverse
  end

  def follower_commits(followers)
    follower_repos.map do |repo|
      fetch_data("#{repo.commit_url}?author=#{repo.follower_name}").map do |commit|
        if commit.is_a?(Hash)
          GithubFollowerCommit.new(commit, repo)
        end
      end
    end.flatten.compact.sort_by { |commit| commit.date }.reverse
  end

  private

  def fetch_data(path)
    parse(client.get(path, {access_token: token}))
  end

  def parse(response)
    JSON.parse(response.body)
  end
end
