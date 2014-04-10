json.array! @newsletters do |newsletter|
  json.extract! newsletter, :id, :title, :content
end
