require 'rails_com'
module RailsAttend
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir[
      "#{config.root}/app/models/absence",
      "#{config.root}/app/models/absence/welfare_leave"
    ]

    config.eager_load_paths += Dir[
      "#{config.root}/app/models/absence",
      "#{config.root}/app/models/absence/welfare_leave"
    ]

    config.generators do |g|
      g.rails = {
        assets: false,
        stylesheets: false,
        helper: false,
        jbuilder: true
      }
      g.templates.unshift File.expand_path('lib/templates', RailsCom::Engine.root)
    end

  end
end
