class StudentPolicy < ApplicationPolicy

  def classmates?
    user.student?
  end
end
