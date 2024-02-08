class User < ApplicationRecord
  rolify
  after_create :assign_default_role # this line has to be below rolify or the role is going to be duplicated

  extend FriendlyId
  friendly_id :email, use: :slugged

  has_many :courses, dependent: :destroy
  has_many :enrollments

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable,
         :confirmable # add it when the send email works

  def to_s
    email
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name email sign_in_count last_sign_in_at current_sign_in_ip]
  end

  def assign_default_role
    add_role(:student) unless has_role? :student
    add_role(:teacher) unless has_role? :teacher
    add_role(:admin) if User.count == 1 && !has_role?(:admin)
  end
end
