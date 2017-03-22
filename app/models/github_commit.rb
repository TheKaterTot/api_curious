class GithubCommit
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def date
    DateTime.parse(data["date"])
  end
end
