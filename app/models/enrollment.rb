class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  # Course.find_each { |course| Course.reset_counters(course.id, :enrollments)}
  belongs_to :user, counter_cache: true
  # User.find_each { |user| User.reset_counters(user.id, :enrollments)}

  validates :user, :course, presence: true
  validates_uniqueness_of :course_id, scope: :user_id
  validates_uniqueness_of :user_id, scope: :course_id

  validate :cant_subscribe_to_own_course

  scope :pending_review, -> { where(rating:[0,nil, ""], review: [0, nil, ""])}
  scope :reviewed, -> { where.not(review: [0, nil, ""])}
  scope :latest_reviews, -> { order(rating: :desc, created_at: :desc).limit(3)}

  def to_s
    user.to_s + " " + course.to_s
  end

  after_save do
    unless rating.nil? || rating.zero?
      course.update_rating
    end
  end

  after_create :calculate_balance
  after_destroy :calculate_balance

  def calculate_balance
    course.calculate_income
    user.calculate_enrollment_expenses
  end

  after_destroy do
    course.update_rating
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
