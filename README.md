# PersistentOpenStruct

Are you inserting data in the same format into OpenStruct again and again?
Wishing OpenStruct wouldn't have to define a new singleton method on each
individual object?  Here's your solution!

PersistentOpenStruct defines methods on the class, so as long as you keep using
the same keys, no new methods will be defined.  It obeys the entire interface
of OpenStruct, so you can insert it into your code without problem!  (Unless
you're using `OpenStruct#delete_field` for some reason; PersistentOpenStruct
refuses to undefine the methods it defines.)

This gives a noticeable performance boost.  Here's a benchmark (found at
benchmark/benchmark.rb):
``` ruby
require 'benchmark/ips'
require 'ostruct'
require_relative '../lib/persistent_open_struct'

Benchmark.ips do |x|
  input_hash = { foo: :bar }
  x.report('OpenStruct') do
    OpenStruct.new(input_hash)
  end

  x.report('PersistentOpenStruct') do
    PersistentOpenStruct.new(input_hash)
  end
end

puts "\n\n"

Benchmark.ips do |x|
  x.report('OpenStruct') do
    OpenStruct.new.foo = :bar
  end

  x.report('PersistentOpenStruct') do
    PersistentOpenStruct.new.foo = :bar
  end
end
```
And the results:
``` ruby
Calculating -------------------------------------
          OpenStruct    16.104k i/100ms
PersistentOpenStruct    59.335k i/100ms
-------------------------------------------------
          OpenStruct    190.217k (± 4.0%) i/s -    966.240k
PersistentOpenStruct    956.108k (± 2.1%) i/s -      4.806M


Calculating -------------------------------------
          OpenStruct    16.162k i/100ms
PersistentOpenStruct    71.622k i/100ms
-------------------------------------------------
          OpenStruct    183.175k (± 2.5%) i/s -    921.234k
PersistentOpenStruct      1.220M (± 2.6%) i/s -      6.159M
```

## Installation

Add this line to your application's Gemfile:

    gem 'persistent_open_struct'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install persistent_open_struct

## Usage

``` ruby
class MyDataStructure < PersistentOpenStruct
end

datum1 = MyDataStructure.new(foo: :bar)

datum2 = MyDataStructure.new
datum2.respond_to?(:baz) #=> false
datum2.respond_to?(:foo) #=> true
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/persistent_open_struct/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
