class GithubService
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def starred_repos
    parse(client.get("/user/starred", {access_token: token}))
  end

  def followers
    parse(client.get("/user/followers", {access_token: token}))
  end

  def following
    parse(client.get("/user/following", {access_token: token}))
  end

  private

  def client
    Faraday.new(url: "https://api.github.com")
  end

  def parse(response)
    JSON.parse(response.body)
  end
end
