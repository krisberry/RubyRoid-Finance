json.array! @users do |user|
  json.label user.full_name
  json.value user.id
end