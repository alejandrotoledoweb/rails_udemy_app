class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def show?
    @record.published && @record.approved || @user.present? && @user.has_role?(:admin) || @user.present? && @record.user.id == @user.id || @record.bought(@user)
  end

  def create?
    @user.has_role?(:teacher) || @user.has_role?(:admin)
  end

  def update?
    @user.present? && (@record.user.id == @user.id ||  @user.has_role?(:admin))
  end

  def destroy?
    @user.present? && @record.user.id == @user.id
  end

  def owner?
    @record.user == @user
  end

  def approve?
    @user.has_role?(:admin)
  end
end
