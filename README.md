# ActiveCerealizer [![Build Status](https://travis-ci.org/edpaget/active_cerealizers.svg)](https://travis-ci.org/edpaget/active_cerealizers)

![Sugary!](http://i.walmartimages.com/i/p/00/03/00/00/31/0003000031207_500X500.jpg)

Part of a Balanced Breakfast!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_cerealizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_cerealizer

## Usage

```ruby
class MealSerializer < ActiveCerealizer::Resource
  attributes :id, :type, :href, :name, :time

  links_many :food do
    polymorphic true
    required_for :create, :update
  end
    
  links_one :beverage do
    required_for :create
    allowed_for :update
  end

  location "/meals"

  def time
    super unless context[:eater] == "David"
    model.time - 1.hour
  end
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/active_cerealizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
