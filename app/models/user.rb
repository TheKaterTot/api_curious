class User < ApplicationRecord
  def self.find_or_create_from_auth(auth)
    User.find_or_create_by(
      provider: auth["provider"],
      name: auth["info"]["name"],
      uid: auth["extra"]["raw_info"]["id"],
      username: auth["info"]["nickname"],
      token: auth["credentials"]["token"]
    )
  end

  def image_url
    "https://avatars3.githubusercontent.com/u/#{uid}?v=3&s=150"
  end

  def starred_repos
    GithubService.new(token).starred_repos.count
  end

  def followers
    GithubService.new(token).followers.map { |follower| follower.name }
  end

  def following
    GithubService.new(token).following.count
  end

  def recent_commits
    GithubService.new(token).commits(self.username)
  end

  def follower_commits
    GithubService.new(token).follower_commits(followers)
  end
end
