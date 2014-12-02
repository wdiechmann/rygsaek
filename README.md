# Rygsaek

Give your models a carry-on to hold all the attachments users may enclose.

**Rygsaek** manages the attachments to models, like images, documents and other files
that should go with the model. 

Say you have a Product model and you would like to attach a few photos of the product,
one or two PDF spec sheets and a bill of materials spreadsheet - **Rygsaek** is your friend!

Now, let's just imagine that you get another variant of that Product and 
want to 'share' the BOM - **Rygsaek** has your back and allows you to attach it to that other 
product without having to copy it (so when the bill of materials change - both products are updated).

Easy was it not?

That first product - remember that one? Well, turns out it has reached it's EOL (End Of Life) so
you go delete it. Deleting it will break the connection to the shared BOM spreadsheet right? No!

The BOM is safe with **Rygsaek** and only the link between the now defunct product and the BOM is gone.

## How does that work?

When you upload your files they are saved to the store of your choice (disk,cloud,which ever option the
storage gem beneath **Rygsaek** offers) and the reference is saved to a tuple/record in a table/dataset labeled 
**attachments** in the data storage persistency gem beneath **Rygsaek**. Then another tuple is created
in a dataset labeled **attachables** which holds a reference to the attachment and to what ever object
you wanted the attachments to referencing/attached to.

And that is really all there is to it!

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

**Rygsaek** relies heavily on [CarrierWave](https://github.com/carrierwaveuploader/carrierwave) which does 
all the heavy-lifting. 

## Usage

### Initial setup

You most probably will start by setting up **Rygsaek**. In order for **Rygsaek** to function it has two tables
that it will create in your database - by default they are labeled attachments and attachables, but 
you are free to name them otherwise!

Go a head and use the generator for this:

    $ rails generate rygsaek:setup --skip_helpers --skip_views --skip_controller --skip_migration --skip_initializer

**Rygsaek** will create view files and a controller for attachments, add a migration to your project, and introduce an initializer in the config/initializers
folder but like you see above, you get to skip the parts you'd prefer to do yourself.

### Model configuration

Once you've setup **Rygsaek** it's time to start using it! 

Models will have to be told that you would like **Rygsaek** to manage enclosures for it. You do that 
with a simple statement in the model class.

```ruby
class SomeModel < ActiveRecord::Base
  has\_rygsaek\_enclosures
  ...
end
```

Some enclosures will require post-processing like image resizing others will find their storage
at some Cloud service like Amazon S3. You provide defaults (other than already in place and commented
in the config/initializers/rygsaek.rb) in the initializer or as options on the model like

```ruby
class SomeModel < ActiveRecord::Base
  has\_rygsaek\_enclosures storage: 'file', 
  												 sizes: { jpg: ['32x32','128x128'], png: '92x92'},
													 types: 'gif,jpg,png,pdf,xls',
													 filsize: { pdf: 1024, gif: 12, png: 256 }
  ...
end
```

With the model configurations out of the way you're well on your way to start attaching uploads to your
models.

### View configuration

Enclosures are usually added to models at some later time - but not necessarily. Adding new 
employees for example might include grabbing a selfie to go with the profile as would persisting
that new contact you meet at random whilst hiking the Himalayan Foot Hills (but **Rygsaek** does not
yet offer any localStorage solution mind you).

####Showing attachments

So - enclosures are divided into 2 basic categories: one-off and galleries:

The one-off kind is typically the employee pic or the product high-res which you present and collect
with this helper:

    <%= view\_photo(@employee, :selfie, :thumb) %>
		
This show action will build this HTML

The gallery type works more or less the same way:

    <%= view\_gallery(@product, :specs, :slideshow) %>

####Editing and adding forms that include attachments

Both helpers (view\_photo and view\_gallery) will take form objects instead and 
thus basically allow you to remember just these two commands!

```ruby

- form_for @employee do |f|
    = view_photo f, :selfie, :thumb, :provide_url_input_too
		= f.input :employee_name
		...

```

###API

Client-side retrieval of persisted data and client-side frameworks like AngularJS will rejoice in **Rygsaek** 
and it's API as it adds RESTful  URL's for retrieving and storing attachments:

	/model/:id/attachments.json
	/model/:id/:field\_name/:size_reference		/employees/3/selfie/thumb
																						/products/bolster-gun-with-grip/specs/slideshow
	FIXME 2014-11-29 whd how to post 3 photos with a new product ?


## Contributing

1. Fork it ( https://github.com/[my-github-username]/rygsaek/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
