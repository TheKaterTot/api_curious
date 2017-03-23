class GithubStarredRepo
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def name
    data["name"]
  end
end
