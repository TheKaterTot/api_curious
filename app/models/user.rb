class User < ApplicationRecord
  def self.find_or_create_from_auth(auth)
    User.find_or_create_by(
      provider: auth["provider"],
      name: auth["info"]["name"],
      uid: auth["extra"]["raw_info"]["id"]
    )
  end
end
