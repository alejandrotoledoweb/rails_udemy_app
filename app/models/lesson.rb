class Lesson < ApplicationRecord
  belongs_to :course

  validates :title, :content, :course, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :content

end
