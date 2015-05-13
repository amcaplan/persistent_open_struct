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
