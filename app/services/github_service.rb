class GithubService
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def starred_repos
    fetch_data("/user/starred")
  end

  def followers
    fetch_data("/user/followers").map do |follower|
      GithubUser.new(follower)
    end
  end

  def following
    fetch_data("/user/following").map do |user|
      GithubUser.new(user)
    end
  end

  private

  def fetch_data(path)
    parse(client.get(path, {access_token: token}))
  end

  def client
    Faraday.new(url: "https://api.github.com")
  end

  def parse(response)
    JSON.parse(response.body)
  end
end
