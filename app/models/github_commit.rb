class GithubCommit
  attr_reader :data, :repo

  def initialize(data, repo)
    @data = data
    @repo = repo
  end

  def date
    DateTime.parse(data["commit"]["committer"]["date"])
  end

  def message
    data["commit"]["message"]
  end

  def repo_name
    repo.name
  end
end
