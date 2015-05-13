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
    bug = '[ruby-core:33010]'
    o = PersistentOpenStruct.new
    refute_respond_to(o, :a)
    refute_respond_to(o, :a=)
    o.a = 'a'
    assert_respond_to(o, :a)
    assert_respond_to(o, :a=)
    a = o.delete_field :a
    refute_respond_to(o, :a, bug)
    refute_respond_to(o, :a=, bug)
    assert_equal(a, 'a')
    s = Object.new
    def s.to_sym
      :foo
    end
    o[s] = true
    assert_respond_to(o, :foo)
    assert_respond_to(o, :foo=)
    o.delete_field s
    refute_respond_to(o, :foo)
    refute_respond_to(o, :foo=)
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
    assert_equal os1, os2
    assert_equal false, os1.eql?(os2)
    refute_equal os1.hash, os2.hash
    assert_equal true, os1.eql?(os1.dup)
    assert_equal os1.hash, os1.dup.hash
  end

  def test_method_missing
    os = PersistentOpenStruct.new
    e = assert_raises(NoMethodError) { os.foo true }
    assert_equal :foo, e.name
    assert_equal [true], e.args
    assert_match(/#{__callee__}/, e.backtrace[0])
    e = assert_raises(ArgumentError) { os.send :foo=, true, true }
    assert_match(/#{__callee__}/, e.backtrace[0])
  end
end
