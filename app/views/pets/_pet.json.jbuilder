json.extract! pet, :id, :petname, :birthday, :weight, :gender, :breed, :user_id, :created_at, :updated_at
json.url pet_url(pet, format: :json)
