json.extract! topic, :id, :teacher_id, :main_topic_id, :title, :progress, :created_at, :updated_at
json.url topic_url(topic, format: :json)
