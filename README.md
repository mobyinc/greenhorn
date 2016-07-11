# Greenhorn
Greenhorn is a Ruby gem that provides an API for accessing a [Craft CMS](https://craftcms.com) instance programmatically, allowing you to modify your CMS data without using the Craft interface. It supports both the core Craft application as well as [Craft Commerce](https://craftcommerce.com/).

Greenhorn aims to provide the behavior you would expect if you were using the Craft interface directly, and abstracts away Craft's idiosyncratic database schema.

# Installation
```
gem install greenhorn
```

# Usage
Greenhorn speaks the language of Craft’s database schema, so it only needs a Craft database to be instantiated:

```
ruby
craft = Greenhorn::Craft.new(
  host: 'localhost',
  username: 'root',
  password: '',
  database: 'my_craft_database'
)
```
