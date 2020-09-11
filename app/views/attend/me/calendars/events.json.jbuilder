json.array! @financial_months.flat_map { |i| i.events } do |event|
  json.start event[:start]
  json.rendering 'background'
  json.color event[:color]
end

json.array! @financial_months.flat_map { |i| i.extras } do |event|
  json.title event[:title]
  json.start event[:start]
end

json.array! @absence_events do |event|
  json.title event['title']
  json.start event['start']
  json.end event['end']
  json.url event['url']
  json.color '#881224'
end

