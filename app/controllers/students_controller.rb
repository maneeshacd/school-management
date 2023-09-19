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

  # @url [GET] /students.json
  #
  # @return [Array<Item>] An array of students in the current school
  def index
    authorize(:student)
    @students = current_user.school.students
  end

  # @url [GET] /students/:id.json
  #
  # @option id [Integer] id of student.
  #
  # @return [Student] Student details
  def show
    authorize(:student)
    @course = Course.find_by(id: params[:course_id])
    @batches = @course ? @course.batches : []
    @student = User.student.find_by(id: params[:id])
  end
end
