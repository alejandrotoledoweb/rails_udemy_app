class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  # to update the counter cache for lessons in user table
  # Course.find_each { |course| Course.reset_counters(course.id, :lessons)}

  validates :title, :content, :course, presence: true

  has_many :user_lessons, dependent: :destroy

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :content

  def to_s
    title
  end

  def viewed(user)
    self.user_lessons.where(user: user).present?
  end
end
