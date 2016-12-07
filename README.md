# Effective Slugs

Automatically generate URL-appropriate slugs when saving a record.

Also overrides ActiveRecord's .find() method to accept the slug, or an id as the parameter.

Rails 3.2.x and Rails 4.


## Getting Started

Add to Gemfile:

```ruby
gem 'effective_slugs'
```

Run the bundle command to install it:

```console
bundle install
```

(optional) If you want control over any excluded slugs, run the generator:

```console
rails generate effective_slugs:install
```

The generator will install an initializer which describes all configuration options.


## Usage

Add the mixin to an existing model:

```ruby
class Post
  acts_as_sluggable
end
```

Then create a migration to add the :slug column to the model.
As we're doing lookups on this column, a database index makes a lot of sense too:

```console
rails generate migration add_slug_to_post slug:string:index
```

which will create a migration something like:

```ruby
class AddSlugToPost < ActiveRecord::Migration
  def change
    add_column :posts, :slug, :string
    add_index :posts, :slug
  end
end
```

Then collect the slug field with your object's form.  The below example will not be displayed on a #new but it will on #edit or if the slug is in error.

```haml
- if f.object.persisted? || f.object.errors.include?(:slug)
  - current_url = (post_path(f.object) rescue nil)
  = f.input :slug, hint: "The slug controls this post's internet address. Be careful, changing the slug will break links that other websites may have to the old address.<br>#{('This post is currently reachable via ' + link_to(current_url.gsub(f.object.slug, '<strong>' + f.object.slug + '</strong>').html_safe, current_url)) if current_url }".html_safe
```

and include the permitted param within your controller:

```ruby
def permitted_params
  params.require(:post).permit(:slug)
end
```

## Behavior

### Slug Generation

When saving a record that does not have a slug, a slug will be automatically generated and assigned.

Tweak the behavior by adding the following instance method to the model:

```ruby
def should_generate_new_slug?
  slug.blank?
end
```

The slug is generated based on an object's `slug_source` method, which can also be overridden by adding the following to the model:

```ruby
def slug_source
  return title if self.respond_to?(:title)
  return name if self.respond_to?(:name)
  to_s
end
```

There is also the idea of excluded slugs.  Every model in a rails application has its default route automatically excluded.
So if you have a model called Event, with its corresponding 'events' table, the /events slug will be unavailable.

You can add additional excluded slugs in the generated config file.

Any slug conflicts will be resolved by appending a -1, -2, etc to the slug.

### Finder Methods

```ruby
post = Post.create(:title => 'My First Post')
post.id
  => 1
post.slug
  => 'my-first-post'
```

The .find() ActiveRecord method is overridden so the following are equivelant:

```ruby
Post.find('my-first-post')
Post.find(1)
Post.where(:slug => 'my-first-post').first
```

## License

MIT License.  Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)

## Credits

Some of the code in this gem was inspired by an old version of FriendlyId (https://github.com/FriendlyId/friendly_id)

## Testing

The test suite for this gem is unfortunately not yet complete.

Run tests by:

```ruby
rake spec
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request


