class StudentsController < ApplicationController

  def classmates
    @classmates = current_user.classmates
  end
end
