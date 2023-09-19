class StudentPolicy < ApplicationPolicy

  def classmates?
    user.student?
  end

  def index?
    user.school_admin?
  end

  def show?
    user.admin? || user.school_admin?
  end
end
