# Greenhorn
Greenhorn is a Ruby gem that provides an API for accessing a [Craft CMS](https://craftcms.com) instance programmatically, allowing you to modify Craft data without using the interface. It supports both the core Craft application as well as [Craft Commerce](https://craftcommerce.com/). It’s ideal for importing data into a Craft application.

Greenhorn aims to provide the behavior you would expect if you were using the Craft interface directly, and abstracts away Craft's idiosyncratic database schema.

## Status
This is alpha software and only a small fraction of the Craft interface has been implemented. We’re fleshing it out as we go along and things become necessary.

### Implemented Features
* Creating fields
* Creating asset sources using local or S3 provider
* Creating asset files

## Installation
```
gem install greenhorn
```

## Usage
Greenhorn speaks the language of Craft’s database, so it only needs a database instance to get started:

```ruby
require 'greenhorn'

craft = Greenhorn::Connection.new(
  host: 'localhost',
  username: 'root',
  password: '',
  database: 'my_craft_database',
  prefix: 'craft', # only if your database tables are prefixed
  basePath: './my_craft_app' # only if you’ll be using local storage with {basePath}
)
```

### Transactions
When doing a batch of operations, you can wrap your processing in a transaction that will roll back incomplete changes if an error occurs:

```ruby
craft.transaction do
  ...
end
```

### Asset Sources
#### Local Storage
```ruby
image_assets = craft.asset_sources.create(
  name: 'Images',
  type: 'Local',
  path: '{basePath}/images'
  publicUrls: false
)
#=> #<Greenhorn::Craft::AssetSource id: 1, name: "Images", handle: "images", type: "Local", settings: {"publicUrls"=>false, "path"=>"{basePath}/images"}, sortOrder: nil, fieldLayoutId: 6, dateCreated: "2016-08-04 22:26:59", dateUpdated: "2016-08-04 22:26:59", uid: "70fc2f23-4a47-91cc-faa0-dc1aba2914cf">
```

### S3
```ruby
image_assets = craft.asset_sources.create(
  name: 'Images',
  type: 'S3',
  keyId: '<s3_key>',
  secret: '<s3_secret>',
  bucket: 'mybucket',
  publicUrls: true,
  urlPrefix: 'http://s3-us-west-2.amazonaws.com/mybucket',
  location: 'us-west-2',
  subfolder: 'uploads',
  expires: '1year'
)
```

### Fields
```ruby
craft.fields.create(name: 'Description')
#=> #<Greenhorn::Craft::Field id: 3, groupId: 1, name: "Description", handle: "description", context: "global", instructions: nil, translatable: false, type: "PlainText", settings: {"placeholder"=>"", "maxLength"=>"", "multiline"=>"", "initialRows"=>"4"}, dateCreated: "2016-08-04 22:19:02", dateUpdated: "2016-08-04 22:19:02", uid: "f98f4548-492e-0321-f01b-20051230d1a2">
```

If no field type is specified, Greenhorn assumes `PlainText`. Like the Craft interface, Greenhorn will automatically assign a slug (`handle`) if you don't pass one.

```ruby
craft.fields.create(name: 'Ingredients', type: 'RichText')
#=> #<Greenhorn::Craft::Field id: 5, groupId: 1, name: "Ingredients", handle: "ingredients", context: "global", instructions: nil, translatable: false, type: "RichText", settings: {"configFig"=>"", "availableAssetSources"=>"*", "availableTransforms"=>"*", "cleanupHtml"=>"1", "purifyHtml"=>"1", "columnType"=>"text"}, dateCreated: "2016-08-04 22:23:00", dateUpdated: "2016-08-04 22:23:00", uid: "5e8d04e1-0c30-a74d-c78e-04baa566c9de">
```

```ruby
craft.fields.create(name: 'Calories', handle: 'kcal', type: 'Number')
#=> #<Greenhorn::Craft::Field id: 6, groupId: 1, name: "Calories", handle: "kcal", context: "global", instructions: nil, translatable: false, type: "Number", settings: {"min"=>"0", "max"=>"", "decimals"=>"0"}, dateCreated: "2016-08-04 22:23:49", dateUpdated: "2016-08-04 22:23:49", uid: "2d4e25f1-b29b-cc2d-b8f8-ba2e7326d887">
```

```ruby
craft.fields.create(
  name: 'Primary Image',
  type: 'Assets',
  defaultUploadLocationSource: image_assets,
  singleUploadLocationSource: image_assets,
  allowedKinds: ['image']
)
```

```ruby
craft.fields.create(
  name: 'Nutritional Information',
  type: 'Matrix',
  block_types: [
    {
      name: 'Information Item',
      fields: [
        { name: 'Name', type: 'PlainText' },
        { name: 'Value', handle: 'href', type: 'PlainText' }
      ]
    }
  ]
)
```

### Sections
```ruby
case_studies = craft.sections.create(
  name: 'Recipes',
  type: 'structure',
  fields: %w(description primaryImage ingredients calories nutritionalInformation)
)
```
When associating a field with a resource, you can just tell Greenhorn its handle.

### Entries
```ruby
tacos  = craft.entries.create(
  section: case_studies,
  title: 'Tacos'
)

tacos_al_pastor  = craft.entries.create(
  parent: tacos,
  title: 'Tacos al Pastor',
  primaryImage: 'tacos/al_pastor.jpg',
  ingredients: '1 large white onion, halved, 1 pineapple, peeled, cut crosswise into 1/2-inch-thick rounds, 1/2 cup fresh orange juice…',
  description: 'These pineapple and pork tacos are the original fusion food—a cross between Middle Eastern shawarma and the guajillo-rubbed grilled pork…'
)
```

### Commerce
```ruby
cookbooks = craft.commerce.product_types.create(
  name: 'Cookbooks',
  hasVariants: true,
  fields: %w(
    description
    primaryImage
  ),
  variant_fields: ['primaryImage']
)

craft.commerce.products.create(
  title: 'Tacos 101',
  type: cookbooks,
  defaultSku: '12345',
  defaultPrice: 39.95
)
```

### Reasons + Neo fields
You can add conditional logic directly to any `FieldLayout` record by calling `set_conditions`:

```ruby
fl = craft.neo.block_types.find_by(name: 'Billboard').field_layout
fl.set_conditions(
  nightMode: [
  # nightMode will only be shown if...
    [
      { field: 'billboardType', equals: 'image' }, # and
      { field: 'numberOfColumns', equals: '6' } # and
    ], # or
    [
      { field: 'billboardType', does_not_equal: 'image' }
    ]
  ]
)
```

or you can pass `conditions` to a block type hash when creating a Neo field:

```ruby
billboard_content_blocks = craft.fields.create!(
  name: 'Reasons Billboard Content Blocks',
  type: 'Neo',
  block_types: [
    {
      name: 'Background',
      topLevel: false,
      maxBlocks: 1,
      fields: [
        'backgroundType',
        'color',
        'image'
      ],
      conditions: {
        color: [
          [ { field: 'backgroundType', equals: 'color' } ]
        ]
      }
    }
  ]
)
```
