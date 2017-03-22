class GithubFollowerRepo
  attr_reader :follower, :repo

  def initialize(follower, repo)
    @follower = follower
    @repo = repo
  end

  def owner
    repo["owner"]["login"]
  end

  def follower_name
    follower.name
  end

  def repo_name
    repo["name"]
  end

  def commit_url
    "/repos/#{owner}/#{repo_name}/commits"
  end
end
