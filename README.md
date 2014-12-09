[![Build Status](https://api.travis-ci.org/wdiechmann/rygsaek.png?branch=master)](http://travis-ci.org/wdiechmann/rygsaek)
[![Coverage Status](https://coveralls.io/repos/wdiechmann/rygsaek/badge.png)](https://coveralls.io/r/wdiechmann/rygsaek)

## Rygsaek

Give your models a carry-on to hold all the enclosures users may upload.

**Rygsaek** manages the enclosures to models, like images, documents and other files
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

###How does that work?

There are a few use cases described like this:

UC1: You're sitting on a pile of files that will need to be stored (dropbox like)
You upload the files - a preset number of GB at a time - without attention to any references or details.

UC2: You got an email with an attached .docx file that should be referenced by the sender
You lookup the sender (in your app) and drop the file on her

UC3: You've shot a few photos that will need captions, location, other details
You upload the photos to an app that will allow details be added to every file/upload

UC4: You uploaded a photo and referenced it on a product - now you've got a new product that need that pic too
You lookup the 'old' product, make a note of the photo reference, find the new product and add the reference - OR - 
you find the new product and searches, and selects, the photo with the gallery tool.

Initially you will define - at least - one **rygsaek**, telling it what kind of storage to use (memory, disk, cloud of sorts).
This implies, of cause, that you may operate any number of concurrent rygsaeks all within the same app. One for important documents, another for 
non-important photos, yet another for employee screenings, etc. Each rygsaek may be organized slightly different without
interfering with the other rygsaeks. Some files you store in the cloud, other goes on disk and yet some goes into the database!

You add a ```carries_rygsaek``` on each models/MODEL.rb that will reference enclosures of some kind (documents, pics, 
what-ever) and possibly you add a number of options - like which rygsaek to use, what file types and -sizes to accept, 
any kind of post processing, etc. Or you go with the default, which is:

		carries_rygsaek :enclosures, options: {rygsaek: 'file on disk', file_type: [:jpg,:png,:gif], file_size: 512}

The above statement could be written like

		carries_rygsaek

(which is done automagically using the ```rails g rygsaek some_model``` command).

Notice too, how the **field name** symbol is plural - identifying that you expect more photos to be uploadable/viewable - 
which will be a hint to the view\_helper to accept/display more photos 'out of the box'. You could easily add another reference
to a singular enclosure, using ```rails g rygsaek some_model lease``` (where _lease_ would identify the enclosure reference - 
an attribute on the model referring to a singular enclosure).

Add a reference to the enclosure on the views/MODELs/\_form.html.haml - using either the view_photo or view\_gallery helper - both 
accepts a form object which makes it an easy add :)

If you - like in the example above - labeled the field reference ```:enclosures``` you'd allow more documents to be uploaded
even if you add the ```view_photo``` helper, but when display enclosures, the view\_photo helper will only display the
last enclosure added (the one with the largest :id).

Now hit your MODELs/new or MODELs/:id/edit (like /posts/new or /posts/1/edit) and try adding an enclosure! When you upload your files 
they are saved/transferred to the rygsaek of your choice (ie stored on disk, persisted to some database, uploaded to some cloud service, et al)
and the file reference, is saved to a tuple/record in a table/dataset labeled **rygsaek\_items** which holds a reference to the rygsaek in question, 
a file reference, and a details field. And a tuple/record in a table/dataset labeled **rygsaek\_item\_links** is created
with a reference to the **rygsaek\_items** tuple/record and a reference to the model, id, and field (in our example here that 
would be the posts/1!)

At upload time you get to make a choice what details to add to the record. Details are serialized and stored in the details 
field. If there is no association/reference to any other instance, you're done. Otherwise another tuple is created in a 
dataset labeled **rygsaek\_item\_links** which holds a reference to the rygsaek, to the rygsaek\_item, and to what ever object
you wanted the 'attachment' to reference/attach to.

And that is really all there is to it!

###Installation

Add this line to your application's Gemfile:

```ruby
gem 'rygsaek'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rygsaek

###Dependencies

**Rygsaek** relies heavily on [CarrierWave](https://github.com/carrierwaveuploader/carrierwave) which does 
all the heavy-lifting. 

###Usage

### Initial setup

You most probably will start by setting up **Rygsaek**. In order for **Rygsaek** to function it has three tables
that it will create in your database - by default they are labeled rygsaek, rygsaek\_items, and rygsaek\_item\_links, but 
you are free to set your own prefix name them otherwise!

Getting a firm footing - start by using the generator for this:

    $ rails generate rygsaek:install
		
**Rygsaek** will introduce a localization in the config/locale and an initializer in the config/initializers
folder and after running the install generator, you really should browse the config/initializers/rygsaek.rb 
briefly. It contains Rygsaek defaults which you probably would like to adjust to your environment.

Done that? Then go ahead and generate 'rygsaek' with your first model (that requires 'a rygsaek') as scope

		$ rails generate rygsaek MODEL FIELD

On the first model on which you run the generator, **Rygsaek** will add migrations to your project, 
and controllers for rygsaeks, and rygsaek\_items, and on every model, **Rygsaek** will create view files, view\_helpers, and a partial for 
rygsaek\_item\_links





but you get to decide what parts you'd like to erect yourself,

    $ rails generate rygsaek:setup
		
			--prefix=rygsaek (rygsaek, rygsaek_items, and rygsaek_item_links)
			--skip_views 
			--skip_helpers 
			--skip_controllers 
			--skip_migrations 
			--skip_initializer
			
If you skip, say the views, you will be able to customize the views later on by running this command

		$ rails g rygsaek:views
		
which will copy all **Rygsaek** views to views/rygsaek/ folders. Likewise for helpers, controllers, and migrations



### Model configuration

Once you've setup **Rygsaek** it's time to start using it! 

Models will have to be told that you would like **Rygsaek** to manage enclosures for it. You do that 
with a simple statement in the model class.

```ruby
class SomeModel < ActiveRecord::Base
  carries_rygsaek
  ...
end
```

Some enclosures will require post-processing like image resizing others will find their storage
at some Cloud service like Amazon S3. You provide defaults (other than already in place and commented
in the config/initializers/rygsaek.rb) in the initializer or as options on the model like

```ruby
class SomeModel < ActiveRecord::Base
  carries_rygsaek	storage: 'file', 
		sizes: { jpg: ['32x32','128x128'], png: '92x92'},
		types: 'gif,jpg,png,pdf,xls',
		filsize: { pdf: 1024, gif: 12, png: 256 }
  ...
end
```

With the model configurations out of the way you're well on your way to start attaching uploads to your
models.

####Multiple references on a model

You can get away with referencing any number of enclosures on a model - like

* some\_models/:id/photo
* some\_models/:id/documents
* some\_models/:id/bills\_of\_material

The default - enclosures - will (unless you change the configuration) always be available - like

* some\_models/:id/enclosures

and contain all enclosures on the instance.

You describe this to **Rygsaek** in this way:

```ruby
class SomeModel < ActiveRecord::Base
  carries_rygsaek	{ 
		:photo, options:{},
		:documents, options:{},
		:bills_of_material, options:{},
	}
  ...
end
```

####Singular vs plural references

You might wonder what the difference between ```some_instance.enclosures``` and ```some_instance.enclosure``` really boils
down to!?

The plural form (given that the field reference is _photos_) does:

		enclosures.where(field: 'photo')

builds this kind of SQL: 

		select * from rygsaek_items 
		inner join rygsaek_item_links on rygsaek_items.id = rygsaek_item_links.ryg_saek_item_id
		inner join some_model on some_model.id = rygsaek_item_links.model_id and rygsaek_item_links.model_type == 'SomeModel'

The singular form (given that the field reference is _photo_) does:

		enclosures.where(field: 'photo').last
		
This indicates that any number of photos might be uploaded even if the reference is singular - but that ultimately comes
down to the view\_helper! If you insert a reference to ```view\_gallery :photo``` (or you insert ```carries_rygsaek :photos```
on the model), you view effectively imply that more photos may be uploaded. 

To battle this - the singular always looks for any number of enclosures of the field in question - and then returns the last found.



### View configuration

Enclosures are usually added to models at some later time - but not necessarily. Adding new 
employees for example might include grabbing a selfie to go with the profile as would persisting
that new contact you meet at random whilst hiking the Himalayan Foot Hills (but **Rygsaek** does not
yet offer any localStorage solution mind you, so without the Nepalese Telecom to provide some decent
bandwidth, carrying all your electronic devices may prove futile!).

####Showing attachments

So - enclosures are divided into 2 basic categories: one-off and galleries:

The one-off kind is typically the employee pic or the product high-res which you present and collect
with this helper:

	<%= view_photo(@employee, :selfie, :thumb) %>
		
The show action mentioned on the previous line will build this HTML

	<div class="rygsaek-photo" >
		<img src="" />
		<div class="rygsaek-control-panel">
			<div class="" ><i class="icon-pencil"></div>
			<div class="" ><i class="icon-floppy"></div>
			<div class="" ><i class="icon-trash"></div>
			<div class="" ><i class="icon-folder"></div>
		<\/div>
	<\/div>

The gallery type works more or less the same way:

	<%= view_gallery(@product, :specs, :slideshow) %>

	FIXME 2014-12-04 whd what html to write

####Editing and adding forms that include enclosures

Both helpers (view\_photo and view\_gallery) will take form objects instead and 
thus basically allow you to remember just these two commands!

```ruby

- form_for @employee do |f|
		= f.input :employee_name
    = view_photo f, :selfie, :thumb, :provide_url_input_too
		= view_gallery f, :specs, :thumb, :url_to_load_enclosures_from
		...

```

###API

Client-side retrieval of persisted data and client-side frameworks like AngularJS will rejoice in **Rygsaek** 
and it's API as it adds RESTful  URL's for retrieving and storing attachments:

	/model/:id/enclosures.json
	/model/:id/:field_name/:size_reference		/employees/3/selfie/thumb
			/products/bolster-gun-with-grip/specs/slideshow

	FIXME 2014-11-29 whd how to post 3 photos with a new product ?


###Contributing

1. Fork it ( https://github.com/[my-github-username]/rygsaek/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
