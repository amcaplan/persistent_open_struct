require 'test_helper'
require 'persistent_open_struct'

class PersistentOpenStructTest < Minitest::Test
  def test_initialize
    h = {name: "John Smith", age: 70, pension: 300}
    assert_equal h, PersistentOpenStruct.new(h).to_h
    assert_equal h, PersistentOpenStruct.new(PersistentOpenStruct.new(h)).to_h
    assert_equal h, PersistentOpenStruct.new(Struct.new(*h.keys).new(*h.values)).to_h
  end

  def test_equality
    o1 = PersistentOpenStruct.new
    o2 = PersistentOpenStruct.new
    assert_equal(o1, o2)

    o1.a = 'a'
    refute_equal(o1, o2)

    o2.a = 'a'
    assert_equal(o1, o2)

    o1.a = 'b'
    refute_equal(o1, o2)

    o2 = Object.new
    o2.instance_eval{@table = {:a => 'b'}}
    refute_equal(o1, o2)
  end

  def test_equality_of_subclasses
    pos_class = Class.new(PersistentOpenStruct)
    o1 = pos_class.new(foo: :bar)

    pos_class2 = Class.new(pos_class)
    o2 = pos_class2.new(foo: :bar)

    assert_equal(o1, o1.dup)
    refute_equal(o1, o2)
  end

  def test_inspect
    foo = PersistentOpenStruct.new
    assert_equal("#<PersistentOpenStruct>", foo.inspect)
    foo.bar = 1
    foo.baz = 2
    assert_equal("#<PersistentOpenStruct bar=1, baz=2>", foo.inspect)

    foo = PersistentOpenStruct.new
    foo.bar = PersistentOpenStruct.new
    assert_equal('#<PersistentOpenStruct bar=#<PersistentOpenStruct>>', foo.inspect)
    foo.bar.foo = foo
    assert_equal('#<PersistentOpenStruct bar=#<PersistentOpenStruct foo=#<PersistentOpenStruct ...>>>', foo.inspect)
  end

  def test_frozen
    o = PersistentOpenStruct.new
    o.a = 'a'
    o.freeze
    assert_raises(RuntimeError) {o.b = 'b'}
    refute_respond_to(o, :b)
    assert_raises(RuntimeError) {o.a = 'z'}
    assert_equal('a', o.a)
    o = PersistentOpenStruct.new :a => 42
    def o.frozen?; nil end
    o.freeze
    assert_raises(RuntimeError, '[ruby-core:22559]') {o.a = 1764}
  end

  def test_delete_field
    o = PersistentOpenStruct.new
    refute_respond_to(o, :foobar)
    refute_respond_to(o, :foobar=)
    o.foobar = :baz
    assert_equal(o.foobar, :baz)
    assert_respond_to(o, :foobar)
    assert_respond_to(o, :foobar=)
    o.delete_field(:foobar)
    assert_equal(nil, o.foobar)
    assert_respond_to(o, :foobar)
    assert_respond_to(o, :foobar=)
  end

  def test_setter
    os = PersistentOpenStruct.new
    os[:foo] = :bar
    assert_equal :bar, os.foo
    os['foo'] = :baz
    assert_equal :baz, os.foo
  end

  def test_getter
    os = PersistentOpenStruct.new
    os.foo = :bar
    assert_equal :bar, os[:foo]
    assert_equal :bar, os['foo']
  end

  def test_to_h
    h = {name: "John Smith", age: 70, pension: 300}
    os = PersistentOpenStruct.new(h)
    to_h = os.to_h
    assert_equal(h, to_h)

    to_h[:age] = 71
    assert_equal(70, os.age)
    assert_equal(70, h[:age])

    assert_equal(h, PersistentOpenStruct.new("name" => "John Smith", "age" => 70, pension: 300).to_h)
  end

  def test_each_pair
    h = {name: "John Smith", age: 70, pension: 300}
    os = PersistentOpenStruct.new(h)
    assert_equal '#<Enumerator: #<PersistentOpenStruct name="John Smith", age=70, pension=300>:each_pair>', os.each_pair.inspect
    assert_equal [[:name, "John Smith"], [:age, 70], [:pension, 300]], os.each_pair.to_a
    assert_equal 3, os.each_pair.size
  end

  def test_eql_and_hash
    os1 = PersistentOpenStruct.new age: 70
    os2 = PersistentOpenStruct.new age: 70.0
    os3 = Class.new(PersistentOpenStruct).new age: 70
    assert_equal os1, os2
    assert_equal false, os1.eql?(os2)
    refute_equal os1.hash, os2.hash
    assert os1.eql?(os1.dup)
    refute os1.eql?(os3)
    assert_equal os1.hash, os1.dup.hash
  end

  def test_method_missing
    os = PersistentOpenStruct.new
    e = assert_raises(NoMethodError) { os.foobarbaz true }
    assert_equal :foobarbaz, e.name
    assert_equal [true], e.args
    assert_match(/#{__callee__}/, e.backtrace[0])
    e = assert_raises(ArgumentError) { os.send :foobarbaz=, true, true }
    assert_match(/#{__callee__}/, e.backtrace[0])
  end

  def test_method_reuse
    os = PersistentOpenStruct.new
    refute_respond_to(os, :hello)
    refute_respond_to(os, :hello=)
    os.hello = 'world'
    os2 = PersistentOpenStruct.new
    assert_respond_to(os2, :hello)
    assert_respond_to(os2, :hello=)
  end

  PersistentOpenStructClass1 = Class.new(PersistentOpenStruct)
  PersistentOpenStructClass2 = Class.new(PersistentOpenStruct)

  def test_method_segregation
    os1a = PersistentOpenStructClass1.new
    os1a.a_thing = 'value'
    os1b = PersistentOpenStructClass1.new
    assert_respond_to(os1b, :a_thing)
    os2 = PersistentOpenStructClass2.new
    refute_respond_to(os2, :a_thing)
  end
end
