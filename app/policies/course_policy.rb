class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    @user.has_role? :admin
  end

  def update?
    @user.has_role? :admin
  end

  def destroy?
    @user.has_role? :admin || @record.user.id == @user.id
  end
end
