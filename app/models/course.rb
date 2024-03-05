class Course < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 5 }
  validates :short_description, :level, :language, :price, presence: true
  belongs_to :user, counter_cache: true
  # User.find_each { |user| User.reset_counters(user.id, :courses)}

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
      average_rating
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["enrollments", "lessons", "rich_text_description", "user"]
  end

  def bought(user)
    puts "=======> #{user.id}, #{self.id}"
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).any?
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
    else
      update_column :average_rating, (0)

    end
  end
end
