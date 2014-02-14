# FiltersSpam

This is a small Ruby on Rails plugin that can be installed as a gem in your `Gemfile`
that allows models to attach to it to provide spam filtering functionality.

## Rails Quickstart

Add to your Gemfile:

```ruby
gem 'filters_spam', '~> 0.4'
```

Run `bundle install`.

## Usage

Once you have the plugin installed, you need to add a column to the table you will be
using this for. For example, if you have a table called ``comments``:

    script/generate migration add_spam_to_comments spam:boolean
    rake db:migrate

The same thing in Rails 3:

    rails generate migration add_spam_to_comments spam:boolean
    rake db:migrate

Now, you can use it by calling the function in your model like so:

```ruby
filters_spam
```

If you want to change the default fields that are used by ``filters_spam``
then you can pass them in to the method as options. All options are optional.

All of the possible options are outlined below with the default values for each:

```ruby
filters_spam({
  :message_field => :message,
  :email_field => :email,
  :author_field => :author,
  :other_fields => [],
  :extra_spam_words => %w()
})
```

So, say you wanted to mark 'ruby' and 'rails' as spam words you simply pass them
in using the ``:extra_spam_words`` option:

```ruby
filters_spam({
  :extra_spam_words => %w(ruby rails)
})
```

Enjoy a life with less spam.

## Credits

This code was inspired by Russel Norris' [acts_as_snook plugin](http://github.com/rsl/acts_as_snook)
and ideas presented by [Jonathan Snook](http://snook.ca/archives/other/effective_blog_comment_spam_blocker)
