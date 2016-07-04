class PersistentOpenStruct
  # The following 2 methods are altered from the original OpenStruct.
  # Everything else is copied from OpenStruct on Ruby 2.2. (The performance
  # enhancements in 2.3 don't make sense for this implementation.)

  def new_ostruct_member(name)
    name = name.to_sym
    unless respond_to?(name)
      self.class.send(:define_method, name) { @table[name] }
      self.class.send(:define_method, "#{name}=") { |x| modifiable[name] = x }
    end
    name
  end
  protected :new_ostruct_member

  def delete_field(name)
    @table.delete(name)
  end

  # From here on was copied from https://github.com/ruby/ruby/blob/3c7a96bfa2d21336d985ceda544c4ccabafebed5/lib/ostruct.rb
  # to avoid changes to internals negatively affecting performance.

  def initialize(hash=nil)
    @table = {}
    if hash
      hash.each_pair do |k, v|
        k = k.to_sym
        @table[k] = v
        new_ostruct_member(k)
      end
    end
  end

  def initialize_copy(orig)
    super
    @table = @table.dup
    @table.each_key{|key| new_ostruct_member(key)}
  end

  def to_h
    @table.dup
  end

  def each_pair
    return to_enum(__method__) { @table.size } unless block_given?
    @table.each_pair{|p| yield p}
  end

  def marshal_dump
    @table
  end

  def marshal_load(x)
    @table = x
    @table.each_key{|key| new_ostruct_member(key)}
  end

  def modifiable
    begin
      @modifiable = true
    rescue
      raise RuntimeError, "can't modify frozen #{self.class}", caller(3)
    end
    @table
  end
  protected :modifiable

  def method_missing(mid, *args) # :nodoc:
    mname = mid.id2name
    len = args.length
    if mname.chomp!('=')
      if len != 1
        raise ArgumentError, "wrong number of arguments (#{len} for 1)", caller(1)
      end
      modifiable[new_ostruct_member(mname)] = args[0]
    elsif len == 0
      @table[mid]
    else
      err = NoMethodError.new "undefined method `#{mid}' for #{self}", mid, args
      err.set_backtrace caller(1)
      raise err
    end
  end

  def [](name)
    @table[name.to_sym]
  end

  def []=(name, value)
    modifiable[new_ostruct_member(name)] = value
  end

  InspectKey = :__inspect_key__ # :nodoc:

  def inspect
    str = "#<#{self.class}"

    ids = (Thread.current[InspectKey] ||= [])
    if ids.include?(object_id)
      return str << ' ...>'
    end

    ids << object_id
    begin
      first = true
      for k,v in @table
        str << "," unless first
        first = false
        str << " #{k}=#{v.inspect}"
      end
      return str << '>'
    ensure
      ids.pop
    end
  end
  alias :to_s :inspect

  attr_reader :table # :nodoc:
  protected :table

  def ==(other)
    return false unless other.kind_of?(OpenStruct)
    @table == other.table
  end

  def eql?(other)
    return false unless other.kind_of?(OpenStruct)
    @table.eql?(other.table)
  end

  def hash
    @table.hash
  end
end
