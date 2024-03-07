class UserLesson < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :lesson, class_name: "Lesson", foreign_key: "lesson_id"

  validates :user, :lesson, presence: true
  validates_uniqueness_of :lesson_id, scope: :user_id
  validates_uniqueness_of :user_id, scope: :lesson_id

end
