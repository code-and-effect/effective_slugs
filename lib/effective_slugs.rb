require "effective_slugs/engine"
require "effective_slugs/version"

module EffectiveSlugs
  mattr_accessor :excluded_slugs

  def self.setup
    yield self
  end

  # This restricts /events /jobs /posts /pages type slugs, for every model in our application.
  def self.all_excluded_slugs
    Rails.env.development? ? get_all_excluded_slugs : (@@excluded_slugs ||= get_all_excluded_slugs)
  end

  private

  def self.get_all_excluded_slugs
    (ActiveRecord::Base.connection.tables.map { |x| x }.compact + (EffectiveSlugs.excluded_slugs || []))
  end

end
