json.extract! task, :id, :title, :description, :author, :assigned, :expired, :priority, :created_at, :updated_at
json.url task_url(task, format: :json)
