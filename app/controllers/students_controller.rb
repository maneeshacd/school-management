class StudentsController < ApplicationController

  # @url [GET] /batches/:batch_id/classmates.json
  #
  # @option batch_id [Integer] batch id of enrollments.
  #
  # @return [Array<Item>] An array of students, who are the current batch classmates of current student.
  def classmates
    authorize :student
    @batch_id = params[:id]
    @classmates = current_user.classmates(@batch_id)
  end
end
