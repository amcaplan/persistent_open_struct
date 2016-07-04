[![Gem Version](https://badge.fury.io/rb/persistent_open_struct.svg)](http://badge.fury.io/rb/persistent_open_struct)
![Travis badge](https://travis-ci.org/amcaplan/persistent_open_struct.svg?branch=master)

# PersistentOpenStruct

Are you inserting data in the same format into `OpenStruct` again and again?
Wish `OpenStruct` wouldn't have to define a new singleton method on each
individual object?  Here is your solution!

`PersistentOpenStruct` defines methods on the class, so as long as you keep using
the same keys, no new methods will be defined.  The class quickly learns the
shape of your data, so you can use it with minimal overhead.  (Though of course
it's still not as fast as doing the work of defining a full-fledged class.)

It obeys the entire interface of `OpenStruct`, so you can insert it into your code
without problem!  (Unless you're using `OpenStruct#delete_field` for some reason;
`PersistentOpenStruct` refuses to undefine the methods it defines.)

This gives a noticeable performance boost.  Here are the results of the
benchmark found at
[`benchmark/benchmark.rb`](http://github.com/amcaplan/persistent_open_struct/blob/master/benchmark/benchmark.rb)
run on Ruby 2.3.1; the final benchmark is most representative of the average case.

Also included are results for
[`OpenFastStruct`](http://github.com/arturoherrero/ofstruct) as well, to get a
sense of alternative solutions.

More is better.

```
$ ruby benchmark/benchmark.rb
Initialization benchmark

Warming up --------------------------------------
          OpenStruct    88.289k i/100ms
PersistentOpenStruct    78.440k i/100ms
      OpenFastStruct    81.306k i/100ms
        RegularClass   200.536k i/100ms
Calculating -------------------------------------
          OpenStruct    981.150k (± 7.8%) i/s -      4.944M in   5.069950s
PersistentOpenStruct    898.432k (± 9.5%) i/s -      4.471M in   5.022044s
      OpenFastStruct      1.059M (± 5.6%) i/s -      5.366M in   5.086061s
        RegularClass      3.860M (± 9.6%) i/s -     19.251M in   5.034804s

Comparison:
        RegularClass:  3859650.0 i/s
      OpenFastStruct:  1058578.4 i/s - 3.65x slower
          OpenStruct:   981149.5 i/s - 3.93x slower
PersistentOpenStruct:   898431.6 i/s - 4.30x slower



Assignment Benchmark

Warming up --------------------------------------
          OpenStruct   199.451k i/100ms
PersistentOpenStruct   214.181k i/100ms
      OpenFastStruct    99.324k i/100ms
        RegularClass   312.190k i/100ms
Calculating -------------------------------------
          OpenStruct      4.505M (± 5.4%) i/s -     22.538M in   5.019146s
PersistentOpenStruct      4.375M (± 4.2%) i/s -     21.846M in   5.002085s
      OpenFastStruct      1.405M (± 5.0%) i/s -      7.052M in   5.033620s
        RegularClass     11.113M (± 5.2%) i/s -     55.570M in   5.015664s

Comparison:
        RegularClass: 11112511.1 i/s
          OpenStruct:  4504735.3 i/s - 2.47x slower
PersistentOpenStruct:  4375412.9 i/s - 2.54x slower
      OpenFastStruct:  1404724.1 i/s - 7.91x slower



Access Benchmark

Warming up --------------------------------------
          OpenStruct   256.277k i/100ms
PersistentOpenStruct   259.536k i/100ms
      OpenFastStruct   227.602k i/100ms
        RegularClass   260.242k i/100ms
Calculating -------------------------------------
          OpenStruct      6.798M (± 5.0%) i/s -     34.085M in   5.027391s
PersistentOpenStruct      6.539M (± 6.0%) i/s -     32.702M in   5.019393s
      OpenFastStruct      4.875M (± 4.0%) i/s -     24.353M in   5.004194s
        RegularClass      6.654M (± 4.7%) i/s -     33.311M in   5.018183s

Comparison:
          OpenStruct:  6797834.1 i/s
        RegularClass:  6653907.4 i/s - same-ish: difference falls within error
PersistentOpenStruct:  6538883.0 i/s - same-ish: difference falls within error
      OpenFastStruct:  4875059.7 i/s - 1.39x slower



All-Together benchmark

Warming up --------------------------------------
          OpenStruct    14.490k i/100ms
PersistentOpenStruct    63.043k i/100ms
      OpenFastStruct    47.777k i/100ms
        RegularClass   197.293k i/100ms
Calculating -------------------------------------
          OpenStruct    155.130k (± 4.5%) i/s -    782.460k in   5.054693s
PersistentOpenStruct    764.359k (± 6.6%) i/s -      3.846M in   5.053760s
      OpenFastStruct    546.809k (± 4.7%) i/s -      2.771M in   5.079275s
        RegularClass      3.674M (± 9.1%) i/s -     18.348M in   5.054680s

Comparison:
        RegularClass:  3673779.6 i/s
PersistentOpenStruct:   764359.4 i/s - 4.81x slower
      OpenFastStruct:   546808.8 i/s - 6.72x slower
          OpenStruct:   155130.1 i/s - 23.68x slower
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

Changes to functionality require testing.  Performance improvements should
include before/after benchmarks (or ideally just update the results in the
README above).
