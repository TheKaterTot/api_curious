class GithubOrg
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def name
    data["login"]
  end
end
