[![Gem Version](https://badge.fury.io/rb/persistent_open_struct.svg)](http://badge.fury.io/rb/persistent_open_struct)
![Travis badge](https://travis-ci.org/amcaplan/persistent_open_struct.svg?branch=master)

# PersistentOpenStruct

Are you inserting data in the same format into OpenStruct again and again?
Wishing OpenStruct wouldn't have to define a new singleton method on each
individual object?  Here is your solution!

PersistentOpenStruct defines methods on the class, so as long as you keep using
the same keys, no new methods will be defined.  The class quickly learns the
shape of your data, so you can use it with minimal overhead.  (Though of course
it's still not as fast as doing the work of defining a full-fledged class.)

It obeys the entire interface of OpenStruct, so you can insert it into your code
without problem!  (Unless you're using `OpenStruct#delete_field` for some reason;
PersistentOpenStruct refuses to undefine the methods it defines.)

This gives a noticeable performance boost.  Here are the results of the benchmark
found at
[`benchmark/benchmark.rb`](http://github.com/amcaplan/persistent_open_struct/blob/master/benchmark/benchmark.rb);
included are
results for [`OpenFastStruct`](http://github.com/arturoherrero/ofstruct) as
well, to get a sense of alternative solutions.  More is better.

```
$ ruby benchmark/benchmark.rb 
Initialization benchmark

Calculating -------------------------------------
          OpenStruct    17.082k i/100ms
PersistentOpenStruct    61.316k i/100ms
      OpenFastStruct    62.589k i/100ms
        RegularClass   122.018k i/100ms
-------------------------------------------------
          OpenStruct    192.534k (± 3.4%) i/s -    973.674k
PersistentOpenStruct    955.081k (± 3.1%) i/s -      4.783M
      OpenFastStruct    980.760k (± 4.2%) i/s -      4.945M
        RegularClass      3.615M (± 4.4%) i/s -     18.059M


Assignment Benchmark

Calculating -------------------------------------
          OpenStruct   119.904k i/100ms
PersistentOpenStruct   120.998k i/100ms
      OpenFastStruct    67.418k i/100ms
        RegularClass   152.935k i/100ms
-------------------------------------------------
          OpenStruct      3.707M (± 4.7%) i/s -     18.585M
PersistentOpenStruct      3.753M (± 4.0%) i/s -     18.755M
      OpenFastStruct      1.133M (± 2.6%) i/s -      5.731M
        RegularClass      9.155M (± 4.8%) i/s -     45.728M


Access Benchmark

Calculating -------------------------------------
          OpenStruct   134.887k i/100ms
PersistentOpenStruct   134.239k i/100ms
      OpenFastStruct   120.480k i/100ms
        RegularClass   134.040k i/100ms
-------------------------------------------------
          OpenStruct      5.558M (± 3.2%) i/s -     27.787M
PersistentOpenStruct      5.531M (± 4.3%) i/s -     27.653M
      OpenFastStruct      3.996M (± 4.7%) i/s -     20.000M
        RegularClass      5.562M (± 3.5%) i/s -     27.880M
```

## Installation

Add this line to your application's Gemfile:

    gem 'persistent_open_struct'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install persistent_open_struct

## Usage
Note: requires Ruby 2.1.0 or above.

``` ruby
class MyDataStructure < PersistentOpenStruct
end

datum1 = MyDataStructure.new(foo: :bar)

datum2 = MyDataStructure.new
datum2.respond_to?(:baz) #=> false
datum2.respond_to?(:foo) #=> true
```

## Contributing

1. Fork it ( https://github.com/amcaplan/persistent_open_struct/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Pull requests will not be considered without tests of whatever you seek to
change, unless you are submitting a performance improvement.
