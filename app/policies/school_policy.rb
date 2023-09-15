class SchoolPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def show?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def home_edit?
    user.school_admin?
  end

  def destroy?
    user.admin?
  end

  def home?
    user.student? || user.school_admin?
  end
end
