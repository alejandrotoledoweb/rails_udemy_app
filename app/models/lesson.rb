class Lesson < ApplicationRecord
  belongs_to :course

  validates :title, :content, :course, presence: true
  has_rich_text :content

  extend FriendlyId
  friendly_id :title, use: :slugged


end
