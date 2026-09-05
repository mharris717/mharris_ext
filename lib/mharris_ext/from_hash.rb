module FromHash
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def from_hash(ops = {})
      new.from_hash(ops)
    end
  end

  def from_hash(ops)
    ops.each do |k,v|
      send("#{k}=",v)
    end
    self
  end

  def initialize(ops = {})
    from_hash(ops)
  end
end
