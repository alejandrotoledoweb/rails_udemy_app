class Lesson < ApplicationRecord
  include RankedModel
  ranks :row_order, :with_same => :course_id
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :course, counter_cache: true
  # to update the counter cache for lessons in course table
  # Course.find_each { |course| Course.reset_counters(course.id, :lessons)}

  validates :title, :content, :course, presence: true

  has_many :user_lessons, dependent: :destroy


  has_rich_text :content

  def to_s
    title
  end

  def prev
    course.lessons.where("row_order < ?", row_order).order(:row_order).last
  end

  def next
    course.lessons.where("row_order > ?", row_order).order(:row_order).first
  end

  def viewed(user)
    self.user_lessons.where(user: user).present?
  end
end
