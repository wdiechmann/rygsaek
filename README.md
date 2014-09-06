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

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rygsaek/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
