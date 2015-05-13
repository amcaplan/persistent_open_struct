require 'ostruct'

class PersistentOpenStruct < OpenStruct
  VERSION = "0.0.1"

  def new_ostruct_member(name)
    name = name.to_sym
    unless respond_to?(name)
      self.class.send(:define_method, name) { @table[name] }
      self.class.send(:define_method, "#{name}=") { |x| modifiable[name] = x }
    end
    name
  end
end
