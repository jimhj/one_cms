class User < ActiveRecord::Base
  has_secure_password
  has_many :articles, counter_cache: true
  validates :password, length: { minimum: 6 }
  validates_confirmation_of :password
  validates_presence_of :name, :email

  def remember_token
    [id, Digest::SHA512.hexdigest(password_digest)].join('$')
  end

  def self.find_by_remember_token(token)
    user = find_by_id(token.split('$').first)
    (user && Rack::Utils.secure_compare(user.remember_token, token)) ? user : nil
  end
end
