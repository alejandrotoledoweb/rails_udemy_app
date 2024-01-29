class Lessosn < ApplicationRecord
  belongs_to :course

  validates :title,:content, :course, presence: true

  extend FriendlyId
  friendly_idc    :title, use: :slugged


end
