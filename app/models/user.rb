class User < ActiveRecord::Base
  has_secure_password
  has_many :projects, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :discussions, dependent: :nullify
  has_many :tasks, dependent: :nullify
  has_many :favourites, dependent: :destroy
  has_many :favourite_projects, through: :favourites, source: :project
  has_many :teams, dependent: :nullify
  has_many :project_teams, through: :teams, source: :project
  validates :first_name, presence: true, unless: :using_oauth?
  validates :last_name, presence: true, unless: :using_oauth?
  validates :email, presence: true, uniqueness: true, format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, unless: :using_oauth?
  validates :uid, uniqueness: {scope: :provider}, if: :using_oauth?

  PROVIDER_GITHUB = "github"

  serialize :github_raw_data, Hash

  def using_oauth?
    uid.present? && provider.present?
  end

  def using_github?
    using_oauth && provider == PROVIDER_GITHUB
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def self.find_or_create_from_github(github_data)
    user = User.where(uid: github_data["uid"], provider: github_data["provider"]).first
    user = create_from_github(github_data) unless user
    user
  end

  def self.create_from_github(github_data)
    user = User.new
    full_name = github_data["info"]["name"].split(" ")
    user.first_name = full_name.first
    user.last_name = full_name.last
    user.uid = github_data["uid"]
    user.provider = github_data["provider"]
    user.github_token = github_data["credentials"]["token"]
    user.github_secret = github_data["credentials"]["secret"]
    user.github_raw_data = github_data
    user.password = SecureRandom.urlsafe_base64
    user.save
    user
  end

  before_create { generate_token(:auth_token) }
  def generate_token(user)
    begin
      self[user] = SecureRandom.urlsafe_base64
    end while User.exists?(user => self[user])
  end

  def password_reset_token_expired?
    password_reset_sent_at < 3.days.ago
  end

  def increment_login_lockout_count
    if self.login_lockout_count <= 10
      self.login_lockout_count += 1
      update_attribute(:login_lockout_count, self.login_lockout_count)
    else
      update_attribute(:account_lockout, true)
      update_attribute(:login_lockout_count, 0)
    end
  end

  def unlock_account
    update_attribute(:account_lockout, false)
  end
end
