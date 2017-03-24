class User < ApplicationRecord
  def self.find_or_create_from_auth(auth)
    user = User.find_or_create_by(
      provider: auth["provider"],
      name: auth["info"]["name"],
      uid: auth["extra"]["raw_info"]["id"],
      username: auth["info"]["nickname"],
    )
    user.update_attribute(:token, auth["credentials"]["token"])
    user
  end

  def image_url
    "https://avatars3.githubusercontent.com/u/#{uid}?v=3&s=150"
  end

  def repos
    GithubService.new(token).repos
  end

  def starred_repos
    GithubService.new(token).starred_repos
  end

  def organizations
    GithubService.new(token).organizations
  end

  def followers
    GithubService.new(token).followers
  end

  def following
    GithubService.new(token).following
  end

  def recent_commits
    GithubService.new(token).commits(username).take(10)
  end

  def follower_commits
    GithubService.new(token).follower_commits(followers).take(10)
  end
end
