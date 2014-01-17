# ActsAsSluggable
#
# This module automatically generates slugs based on the :title, :name, or :to_s field
# using a before_validation filter
#
# Mark your model with 'acts_as_sluggable'
#
# and create the migration
#
# structure do
#   slug     :string
# end
#
# You can override
# ActsAsSluggable
#
# This module automatically generates slugs based on the :title, :name, or :to_s field
# using a before_validation filter
#
# Mark your model with 'acts_as_sluggable'
#
# and create the migration
#
# structure do
#   slug     :string
# end
#
# You can override
# def should_generate_new_slug?
#   new_record?
# end
#
# and
# def slug_source
#   return title if self.respond_to?(:title)
#   return name if self.respond_to?(:name)
#   to_s
# end
#
# This will work transparently with the ActsAsSiteSpecific, and should "just work"
# Please do not put any unique indexes on the slugs column. Or make it unique [:slug, :site_id]

module ActsAsSluggable
  extend ActiveSupport::Concern

  module ActiveRecord
    def acts_as_sluggable(options = {})
      if self.methods.include?(:is_site_specific) # ActsAsSiteSpecific
        @acts_as_sluggable_opts = {:validation_scope => :site_id}.merge(options)
      else
        @acts_as_sluggable_opts = {}.merge(options)
      end

      include ::ActsAsSluggable
    end
  end

  included do
    before_validation :set_slug, :if => proc { should_generate_new_slug? }

    #attr_accessible :slug
    validates_presence_of :slug
    validates_exclusion_of :slug, :in => EffectiveSlugs.all_excluded_slugs
    validates_format_of :slug, :with => /\A[a-zA-Z0-9_-]*\z/, :message => 'only _ and - symbols allowed'

    if @acts_as_sluggable_opts[:validation_scope]
      validates_uniqueness_of :slug, :scope => @acts_as_sluggable_opts[:validation_scope]
    else
      validates_uniqueness_of :slug
    end

    class_eval do
      class << self
        alias relation_without_sluggable relation
      end

      def self.relation
        @relation = nil unless @relation.class <= relation_class
        @relation ||= relation_class.new(self, arel_table)
      end

      # Gets an anonymous subclass of the model's relation class.
      # This should increase long term compatibility with any gems that also override finder methods
      # The other idea would be to just return Class.new(ActiveRecord::Relation)

      def self.relation_class
        @relation_class ||= Class.new(relation_without_sluggable.class) do
          alias_method :find_one_without_sluggable, :find_one
          alias_method :exists_without_sluggable?, :exists?
          include ActsAsSluggable::FinderMethods
        end
      end
    end
  end

  module ClassMethods
  end

  # We inject these methods into the ActsAsSluggable.relation class, as below
  # Allows us to use sluggable id's identically to numeric ids in Finders
  # And lets all the pages_path() type stuff work
  #
  # This makes all these the same:
  # Post.find(3) == Post.find('post-slug') == Post.find(post)
  module FinderMethods
    protected

    # Find one can be passed 4, "my-slug" or <Object>
    def find_one(id)
      begin
        if id.respond_to?(:slug)
          where(:slug => id.slug).first
        elsif id.kind_of?(String)
          where(:slug => id).first
        end || super
      rescue => e
        super
      end
    end

    def exists?(id = false)
      if id.respond_to?(:slug)
        super :slug => id.slug
      elsif id.kind_of?(String)
        super :slug => id
      else
        super
      end
    end
  end

  def set_slug
    raise StandardError, "ActsAsSluggable expected a table column :slug to exist" unless self.respond_to?(:slug)

    new_slug = slug_source.to_s.try(:parameterize)

    if new_slug.present?
      while EffectiveSlugs.excluded_slugs.include?(new_slug) do
        new_slug << "-" << self.class.name.demodulize.parameterize
      end

      # TODO: Could make this a bit smarter about conflicts
      num_slugs = self.class.name.constantize.where(:slug => new_slug).count
      num_slugs = self.class.name.constantize.where('slug LIKE ?', "#{new_slug}%").count if num_slugs > 0

      num_slugs == 0 ? self.slug = new_slug : self.slug = "#{new_slug}-#{num_slugs}"
    end

    true
  end

  def slug_source
    return title if self.respond_to?(:title)
    return name if self.respond_to?(:name)
    to_s
  end

  def should_generate_new_slug?
    slug.blank?
  end

  def to_param
    slug.present? ? slug_was : id.to_s
  end

end

