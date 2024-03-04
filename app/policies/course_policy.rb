class CoursePolicy < ApplicationPolicy
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
    @record.user.id == @user.id ||  @user.has_role?(:admin)
  end

  def destroy?
    @record.user.id == @user.id
  end

  def owner?
    @record.user == @user
  end
end
