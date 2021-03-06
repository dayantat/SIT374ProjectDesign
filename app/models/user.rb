class User < ApplicationRecord
    attr_accessor :remember_token
    before_save { self.email = email.downcase }
    validates(:name, presence: true, length: {maximum: 50})
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates(:email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false})
    has_secure_password
    validates(:password, presence: true, length: { minimum: 6 })


    #returns the has digest of the given string
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :  BCrypt::Engine.cost #####This line might have issues with Tabs and spaces
# If error occurs here read page 462 Listing 8.21
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
        SecureRandom.urlsafe_base64
    end

    #remembers a user in the DB this is used for persistent sessions.
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
        if remember_digest.nil?
            false
        else
            BCrypt::Password.new(remember_digest).is_password?(remember_token)
        end
    end

    def forget
        update_attribute(:remember_digest, nil)
    end

end
