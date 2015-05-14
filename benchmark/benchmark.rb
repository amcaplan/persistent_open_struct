require 'benchmark/ips'
require 'ostruct'
require 'ofstruct'
require_relative '../lib/persistent_open_struct'

class RegularClass
  attr_accessor :foo

  def initialize(args)
    @foo = args[:foo]
  end
end

puts "Initialization benchmark\n\n"

Benchmark.ips do |x|
  input_hash = { foo: :bar }
  x.report('OpenStruct') do
    OpenStruct.new(input_hash)
  end

  x.report('PersistentOpenStruct') do
    PersistentOpenStruct.new(input_hash)
  end

  x.report('OpenFastStruct') do
    OpenFastStruct.new(input_hash)
  end

  x.report('RegularClass') do
    RegularClass.new(input_hash)
  end
end

puts "\n\nAssignment Benchmark\n\n"

Benchmark.ips do |x|
  os = OpenStruct.new(foo: :bar)
  pos = PersistentOpenStruct.new(foo: :bar)
  ofs = OpenFastStruct.new(foo: :bar)
  rgc = RegularClass.new(foo: :bar)

  x.report('OpenStruct') do
    os.foo = :bar
  end

  x.report('PersistentOpenStruct') do
    pos.foo = :bar
  end

  x.report('OpenFastStruct') do
    ofs.foo = :bar
  end

  x.report('RegularClass') do
    rgc.foo = :bar
  end
end

puts "\n\nAccess Benchmark\n\n"

Benchmark.ips do |x|
  os = OpenStruct.new(foo: :bar)
  pos = PersistentOpenStruct.new(foo: :bar)
  ofs = OpenFastStruct.new(foo: :bar)
  rgc = RegularClass.new(foo: :bar)

  x.report('OpenStruct') do
    os.foo
  end

  x.report('PersistentOpenStruct') do
    pos.foo
  end

  x.report('OpenFastStruct') do
    ofs.foo
  end

  x.report('RegularClass') do
    pos.foo
  end
end
