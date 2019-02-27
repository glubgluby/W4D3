class User < ApplicationRecord
    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: {message: "Password can't be blank"}
    validates :password, length: {minimum: 6, allow_nil: true}

    before_validation :ensure_session_token

    attr_reader :password

    # P : password=(password) line 37
    # R : reset_session_token line 31
    # E : ensure_session_token line 27
    # F : find_by_credentials line 17
    # I : is_password?(password) line 42
    # G : generate_session_token line 23

    def self.find_by_credentials(username, pass)
        user = User.find_by(username: username)
        return user if user && user.is_password?(pass)
        nil
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def ensure_session_token
        self.session_token ||= User.generate_session_token
    end

    def reset_session_token!
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end

    def password=(passkey)
        @password = passkey
        self.password_digest = BCrypt::Password.create(passkey)
    end

    def is_password?(passkey)
        BCrypt::Password.new(self.password_digest).is_password?(passkey)
    end

    has_many :cats,
        foreign_key: :owner_id
    has_many :cat_rental_requests

end