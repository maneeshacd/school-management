class EnrollmentPolicy < ApplicationPolicy
  def index?
    user.admin? || user.school_admin?
  end

  def student_index?
    user.student?
  end

  def new?
    user.student?
  end

  def create?
    user.student?
  end

  def destroy?
    user.student?
  end

  def update?
    user.admin? || user.school_admin?
  end

  def pending?
    user.school_admin?
  end
end
