class User < ApplicationRecord
  include UsersHelper

  before_save do
    self.email = email.mb_chars.downcase.to_s
    self.password = token_encode(self.password)
  end
end
