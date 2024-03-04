# require 'pry'
class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def create?
    @user.has_role?(:teacher) || @user.has_role?(:admin)
  end

  def update?
    @record.course.user_id == @user.id
  end

  def edit?
    @record.course.user_id == @user.id || @user.has_role?(:admin)
  end

  def new?
  end

  def destroy?
    @record.course.user_id == @user.id
  end

  def show?
    # binding.pry
     @record.course.user_id == @user.id || @record.course.bought(@user) || @user.has_role?(:admin)
  end
end
