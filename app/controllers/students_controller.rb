class StudentsController < ApplicationController

  # @url [GET] /batches/:batch_id/classmates.json
  #
  # @option batch_id [Integer] batch id of enrollments.
  #
  # @return [Array<Item>] An array of students, who are the current batch classmates of current student.
  def classmates
    @batch = Batch.find(params[:id])
    @classmates = current_user.classmates(@batch)
  end
end
