json.extract! enrollment, :id, :batch_id, :student_id, :status
json.batch do
  json.id enrollment.batch.id
  json.name enrollment.batch.name
  json.start_date enrollment.batch.start_date
  json.end_date enrollment.batch.end_date
  json.description enrollment.batch.description
end
json.student do
  json.id enrollment.student.id
  json.name enrollment.student.name
  json.email enrollment.student.email
  json.phone_number enrollment.student.phone_number
  json.description enrollment.student.description
end
