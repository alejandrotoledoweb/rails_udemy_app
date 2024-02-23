class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :user, :course, presence: true
  validates_uniqueness_of :course_id, scope: :user_id
  validates_uniqueness_of :user_id, scope: :course_id

  validate :cant_subscribe_to_own_course

  scope :pending_review, -> { where(rating:[0,nil, ""], review: [0, nil, ""])}

  def to_s
    user.to_s + " " + course.to_s
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[course_id created_at id price rating review updated_at user_id course user]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[course user]
  end

  protected

  def cant_subscribe_to_own_course
    if self.new_record?
      if user.id == course.user_id
        errors.add(:base, "You can not subscribe to your own course")
      end
    end
  end
end
