class GithubService
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def starred_repos
    response = client.get("/user/starred", {access_token: token})
    JSON.parse(response.body)
  end

  private

  def client
    Faraday.new(url: "https://api.github.com")
  end
end
