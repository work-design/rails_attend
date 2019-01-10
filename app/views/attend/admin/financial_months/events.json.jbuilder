json.array! @financial_month.events do |event|
  json.start event[:start]
  json.rendering 'background'
  json.color event[:color]
end

json.array! @financial_month.extras do |event|
  json.title event[:title]
  json.start event[:start]
end

