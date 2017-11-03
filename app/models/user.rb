class User < ApplicationRecord
    has_many :microposts, dependent: :destroy
    has_one :quiz, dependent: :destroy
    has_one :diary, dependent: :destroy
    has_many :notifications, dependent: :destroy
    has_many :recipes
    has_many :active_relationships,  class_name: "Relationship",
                                     foreign_key: "follower_id",
                                     dependent: :destroy
    has_many :passive_relationships, class_name:  "Relationship",
                                     foreign_key: "followed_id",
                                     dependent:   :destroy
    has_many :following, through: :active_relationships,  source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save   :downcase_email
    before_create :create_activation_digest
    
    mount_uploader :avatar, AvatarUploader
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
    after_update :crop_avatar
    
    validates :name,  presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    has_one_time_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    
    # Returns the hash digest of the given string.
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    
    # Returns a random token.
    def User.new_token
        SecureRandom.urlsafe_base64
    end
    
    # Remembers a user in the database for use in persistent sessions.
    def remember
       self.remember_token = User.new_token
       update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    
    # Facebook Login
    def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
            user.provider = auth.provider
            user.uid = auth.uid
            user.name = auth.info.name
            user.oauth_token = auth.credentials.token
            user.oauth_expires_at = Time.at(auth.credentials.expires_at)
            user.email = auth.info.email
            user.password = digest(new_token)
            user.fb = true
        end
    end
    
    # Facebook Login with provided email
    def self.from_omniauth_m(auth, mail)
        where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
            user.provider = auth.provider
            user.uid = auth.uid
            user.name = auth.info.name
            user.oauth_token = auth.credentials.token
            user.oauth_expires_at = Time.at(auth.credentials.expires_at)
            user.email = mail
            user.password = digest(new_token)
            user.fb = true
        end
    end
    
    # Forgets a user.
    def forget
        update_attribute(:remember_digest, nil)
    end
    
    # Activates an account.
    def activate
        update_attribute(:activated,    true)
        update_attribute(:activated_at, Time.zone.now)
    end

    def create_diary
        Diary.create(user_id: self.id, id: self.id)
    end

    def check_day
        if !self.diary.nil?
            if !self.diary.days.any?
                self.diary.days.create(date: DateTime.now.to_date)
            else
                if self.diary.days.last.date.to_s!=DateTime.now.to_date.to_s
                    self.diary.days.create(date:DateTime.now.to_date)
                end
            end
        end
    end

    # Sends activation email.
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
    
     # Sets the password reset attributes.
    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest,  User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end

    # Sends password reset email.
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    
    # Returns true if a password reset has expired.
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end
    
    # Defines a user's status feed.
    def feed
        following_ids = "SELECT followed_id FROM relationships
                        WHERE  follower_id = :user_id"
        Micropost.where("user_id IN (#{following_ids})
                        OR user_id = :user_id", user_id: id)
    end
    
    # Follows a user.
    def follow(other_user)
        following << other_user
    end

    # Unfollows a user.
    def unfollow(other_user)
        following.delete(other_user)
    end

    # Returns true if the current user is following the other user.
    def following?(other_user)
        following.include?(other_user)
    end
    
    def crop_avatar
        avatar.recreate_versions! if crop_x.present?
    end
    
    private
        # Converts email to all lower-case.
        def downcase_email
            self.email = email.downcase
        end

        # Creates and assigns the activation token and digest.
        def create_activation_digest
            self.activation_token  = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
                        
    
end
