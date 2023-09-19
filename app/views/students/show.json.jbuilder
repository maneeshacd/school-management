json.partial! "user", user: @student

json.enrolled_batches @student.student_enrollments.approved do |en|
  json.extract! en.batch, :id, :name, :start_date, :end_date
end
