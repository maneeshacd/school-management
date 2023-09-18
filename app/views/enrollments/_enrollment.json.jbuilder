json.extract! enrollment, :id, :batch_id, :student_id, :status
json.batch do
  json.id enrollment.batch.id
  json.name enrollment.batch.name
  json.description enrollment.batch.description
end
json.student do
  json.id enrollment.student.id
  json.name enrollment.student.name
  json.description enrollment.student.description
end
