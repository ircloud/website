json.array! @newsletter_users do |newsletter_user|
  json.extract! newsletter_user, :id, :email
end
