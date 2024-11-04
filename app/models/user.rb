class User < ApplicationRecord
  before_save {self.email = email.downcase}
  has_one_attached :profile_photo
  has_one_attached :cover_photo

  #URL取得メソッド
  def profile_photo_url
    if profile_photo.attached?
      Rails.application.routes.url_helpers.rails_blob_url(profile_photo, only_path: true)
    else
      nil
    end
  end

  def cover_photo_url
    if cover_photo.attached?
      Rails.application.routes.url_helpers.rails_blob_url(cover_photo, only_path: true)
    else
      nil
    end
  end

  #画像のバリデーション
  validates :profile_photo, content_type: { in: %w[image/jpeg image/png image/gif],
    message: '対応している画像形式はJPEG、PNG、GIFです' },
    size: { less_than: 5.megabytes,
    message: '5MB以下の画像を選択してください' },
    if: -> { profile_photo.attached? }
  validates :cover_photo, content_type: { in: %w[image/jpeg image/png image/gif],
    message: '対応している画像形式はJPEG、PNG、GIFです' },
    size: { less_than: 10.megabytes,
    message: '10MB以下の画像を選択してください' },
    if: -> { cover_photo.attached? }

  #名前のバリデーション
  validates :name, presence: true, length: {maximum:25}

  #メールのバリデーション
  EMAIL_VALIDATE = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 105 },
                    format: { with: EMAIL_VALIDATE }

  #パスワードのバリデーション
  has_secure_password
  validates :password, presence: true,
                      length: { minimum: 6 },
                      allow_nil: true
end
