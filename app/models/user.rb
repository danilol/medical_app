class User < ActiveRecord::Base
  before_create :encrypt_password

  validates :email,    :presence =>true, :uniqueness=>true
  validates :email,     format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :name,     :presence =>true, :uniqueness=>true
  validates :password, :presence =>true, :length => { :minimum => 5, :maximum => 40 }, :confirmation => true

  def self.md5(text)
    Digest::MD5.hexdigest(text)
  end

  def encrypt_password
    if password.present?
      self.password = Digest::MD5.hexdigest(self.password)
    end
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    user if user && user.password == md5(password)
  end

  def admin?
    self.role == 'admin'
  end

  private

  def generate_digest_token
    Digest::SHA1.hexdigest(SecureRandom.base64)
  end
end
