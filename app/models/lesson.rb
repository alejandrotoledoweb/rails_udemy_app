class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  # to update the counter cache for lessons in user table
  # Course.find_each { |course| Course.reset_counters(course.id, :lessons)}

  validates :title, :content, :course, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :content

end
