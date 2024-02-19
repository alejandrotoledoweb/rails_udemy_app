class Course < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 5 }
  validates :short_description, :level, :language, :price, presence: true
  belongs_to :user

  has_rich_text :description
  has_many :lessons, dependent: :destroy
  has_many :enrollments

  def to_s
    title
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      description
      id
      id_value
      language
      level
      price
      short_description
      slug
      title
      updated_at
      user_id
    ]
  end

  def bought(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id].empty?)
  end
end
