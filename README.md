# Skrape

This is a very simple skraping api. It uses nokogiri and it's intended
to be very easy to use. Keep in mind it's still at a very early stage in
development, and lots of changes might happen.

## Installation

Add this line to your application's Gemfile:

    gem 'skrape'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install skrape

## Usage

You can easily define your scrapers and use them with `Skrape.define`

    scraper = Skrape.define do
      sel "h1", :title
      sel "ul > li", :items do
        sel ".name", :name
      end
    end

    scraper.scrape(html)

    # the return will be something like
    {
      title: "Title",
      items: [
        {name: "Item 1"},
        {name: "Item 2"}
      ]
    }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
