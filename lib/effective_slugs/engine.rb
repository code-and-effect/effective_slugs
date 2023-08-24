require_relative '../../app/models/concerns/acts_as_sluggable.rb'

module EffectiveSlugs
  class Engine < ::Rails::Engine
    engine_name 'effective_slugs'

    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    # Include acts_as_addressable concern and allow any ActiveRecord object to call it
    initializer 'effective_slugs.active_record' do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.extend(ActsAsSluggable::ActiveRecord)
      end
    end

    # Set up our default configuration options.
    initializer "effective_slugs.defaults", :before => :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_slugs.rb")
    end

  end
end
