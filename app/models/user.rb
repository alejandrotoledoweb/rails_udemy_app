class User < ApplicationRecord
  rolify
  after_create :assign_default_role # this line has to be below rolify or the role is going to be duplicated

  extend FriendlyId
  friendly_id :email, use: :slugged

  has_many :courses, dependent: :nullify
  has_many :enrollments, dependent: :nullify
  has_many :user_lessons, dependent: :nullify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable
        #  :omniauthable, omniauth_providers: %i[google_oauth2]
        #  :confirmable # add it when the send email works

  # def self.from_omniauth(access_token)
  #   data = access_token.info
  #   user = User.where(email: data['email']).first

  #   # Uncomment the section below if you want users to be created if they don't exist
  #   unless user
  #       user = User.create(name: data['name'],
  #          email: data['email'],
  #          password: Devise.friendly_token[0,20]
  #       )
  #   end
  #   user
  # end

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
end
