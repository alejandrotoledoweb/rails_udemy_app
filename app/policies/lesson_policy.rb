class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    # @record.course.user_id == @user.id
  end

  def update?
    @record.course.user_id == @user.id
  end

  def edit?
    @record.course.user_id == @user.id
  end

  def new?
  end

  def destroy?
    @record.course.user_id == @user.id

  end
end
