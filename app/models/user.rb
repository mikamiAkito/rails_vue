class User < ApplicationRecord
  before_save {self.email = email.downcase}

  #名前のバリデーション
  validates :name, presence :true, length: {maximum:25}

  #メールのバリデーション
  EMAIL_VALIDATE = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 105 },
                    format: { with: VALID_EMAIL_REGEX }

  #パスワードのバリデーション
  has_secure_password
  validates :password, presence: true,
                      length: { minimum: 6 },
                      allow_nil: true
end
