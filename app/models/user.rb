# require "pry"

class User < ApplicationRecord
  rolify
  after_create :assign_default_role # this line has to be below rolify or the role is going to be duplicated

  extend FriendlyId
  friendly_id :email, use: :slugged

  has_many :courses, dependent: :nullify
  has_many :enrollments, dependent: :nullify
  has_many :user_lessons, dependent: :nullify

  has_one_attached :avatar
  after_save :replace_avatar, if: -> { avatar.attached? && saved_change_to_attribute?(:avatar) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable,
         :omniauthable, omniauth_providers: %i[google_oauth2 github]
  #  :confirmable # add it when the send email works

  def self.from_omniauth(access_token)
    data = access_token.info

    user = User.where(email: data["email"]).first

    if user && !user.avatar.attached?
      attach_user_avatar_from_url(user, data["image"]) if data["image"]
    end

    if user && user.name.blank? && data["first_name"] && data["last_name"]
      user.name = "#{data["first_name"]} #{data["last_name"]}"
    end

    if user
      user.provider = "yes"
      user.save!
    end

    # user.save! if user.changed?
    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create(name: data["name"],
                         email: data["email"],
                         password: Devise.friendly_token[0, 20],
                         provider: "yes")
      attach_user_avatar_from_url(user, data["image"]) if data["image"]
    end
    user
  end

  def self.attach_user_avatar_from_url(user, url)
    require "open-uri"
    file = URI.open(url)
    user.avatar.attach(io: file, filename: File.basename(URI.parse(url).path))
  end

  def to_s
    email
  end

  def username
    self.email.split(/@/).first
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name email sign_in_count last_sign_in_at current_sign_in_ip]
  end

  def assign_default_role
    add_role(:student) unless has_role? :student
    add_role(:teacher) unless has_role? :teacher
    add_role(:admin) if User.count == 1 && !has_role?(:admin)
  end

  def buy_course(course)
    self.enrollments.create(course: course, price: course.price)
  end

  def view_lesson(lesson)
    unless self.user_lessons.where(lesson: lesson).any?
      self.user_lessons.create(lesson: lesson)
    end
  end

  def calculate_course_income
    update_column :course_income, (courses.map(&:income).sum)
    # update_column :enrollment_expences, (enrollments.map(&:price).sum)
    update_column :balance, (course_income - enrollment_expences)
  end

  def calculate_enrollment_expenses
    update_column :enrollment_expences, (enrollments.map(&:price).sum)
    update_column :balance, (course_income - enrollment_expences)
  end

  def provider?
    provider.present?
  end

  private

  def replace_avatar
    if avatar.previous_changes.any?
      # This ensures we only attempt to purge if there was a previous file
      avatar.attachment.purge_later
    end
  end
end
