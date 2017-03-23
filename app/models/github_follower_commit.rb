class GithubFollowerCommit
  attr_reader :data, :repo

  def initialize(data, repo)
    @data = data
    @repo = repo
  end

  def follower_name
    data["commit"]["committer"]["name"]
  end

  def date
    DateTime.parse(data["commit"]["committer"]["date"])
  end

  def message
    data["commit"]["message"]
  end

  def repo_name
    repo.repo_name
  end
end
