class GithubRepo
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def name
    data["name"]
  end

  def owner
    data["owner"]["login"]
  end

  def commit_url
    "/repos/#{owner}/#{name}/commits"
  end

end
