module EffectiveSlugs
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Creates an EffectiveSlugs initializer in your application."

      source_root File.expand_path("../../templates", __FILE__)

      def copy_initializer
        template "effective_slugs.rb", "config/initializers/effective_slugs.rb"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
