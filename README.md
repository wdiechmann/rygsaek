# Rygsaek

Give your models a carry-on to hold all the attachments users may enclose.

Rygsaek manages the attachments to models, like images, documents and other files
that should go with the model. It does so by inserting references to enclosures
in a table labeled **attachments** and establishes the link between references in
this table with you model via another table labeled **attachables**.

Say you have a Product model and you would like to attach a few photos of the product,
one or two PDF spec sheets and a bill of materials spreadsheet - **rygsaek** is your friend!

When you get another variant of that Product and want to 'share' the BOM - rygsaek has your back
and allows you to attach it to that other product without having to copy it (so when the bill
of materials change - both products are updated).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rygsaek'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rygsaek

## Dependencies

Rygsaek relies heavily on [CarrierWave](https://github.com/carrierwaveuploader/carrierwave) which does 
all the heavy-lifting. 


## Usage

### Initial setup

You most probably will start by setting up Rygsaek. In order for Rygsaek to function it has two tables
that it will create in your database - by default they are labeled attachments and attachables, but 
you are free to name them otherwise!

Go a head and use the generator for this:

    $ rails generate rygsaek:setup --skip_views --skip_controller --skip_migration --skip_initializer

Rygsaek will create view files and a controller for attachments, add a migration to your project, and introduce an initializer in the config/initializers
folder but like you see above, you get to skip the parts you'd prefer to do yourself.

### Model configuration

Models will have to be told that you would like Rygsaek to manage enclosures for it. You do that 
with a simple statement in the model class.

```ruby
class SomeModel < ActiveRecord::Base
  rygsaek_enclosures
  ...
end
```

Some enclosures will require post-processing like image resizing others will find their storage
at some Cloud service like Amazon S3. You provide defaults (other than already in place and commented
in the config/initializers/rygsaek.rb) in the initializer or as options on the model like

```ruby
class SomeModel < ActiveRecord::Base
  rygsaek_enclosures storage: 'file', 
  					 sizes: { jpg: ['32x32','128x128'], png: '92x92'},
					 types: 'gif,jpg,png,pdf,xls',
					 filsize: { pdf: 1024, gif: 12, png: 256 }
  ...
end
```

### View configuration

Enclosures are usually added to models at some later time - but not necessarily. Adding new 
employees for example might include grabbing a selfie to go with the profile as would persisting
that new contact you meet at random whilst hiking the Himalayan Foot Hills (but Rygsaek does not
yet offer any localStorage solution mind you).

So - enclosures are divided into 2 basic categories: one-off and galleries

The one-off kind is typically the employee pic or the product high-res which you present and collect
with this helper:

    <%= view_photo(@employee, :selfie, :thumb) %>

The gallery type works more or less the same way:

    <%= view_gallery(@product, :specs, :slideshow) %>

Both helpers will take form objects instead and thus basically allow you to remember just these
two commands!

```ruby

- form_for @employee do |f|
    = view_photo f, :selfie, :thumb, :provide_url_input_too
	= f.input :employee_name
	...

```



## Contributing

1. Fork it ( https://github.com/[my-github-username]/rygsaek/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
