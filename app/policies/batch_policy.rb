class BatchPolicy < ApplicationPolicy
  def new?
    user.admin? || user.school_admin?
  end

  def edit?
    user.admin? || user.school_admin?
  end

  def destroy?
    user.admin? || user.school_admin?
  end

  def create?
    user.admin? || user.school_admin?
  end

  def update?
    user.admin? || user.school_admin?
  end
end
