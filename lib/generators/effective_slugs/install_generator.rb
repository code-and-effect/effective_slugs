module EffectiveSlugs
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Creates an EffectiveSlugs initializer in your application."

      source_root File.expand_path('../../templates', __FILE__)

      def copy_initializer
        template ('../' * 3) + 'config/effective_slugs.rb', 'config/initializers/effective_slugs.rb'
      end
    end
  end
end
