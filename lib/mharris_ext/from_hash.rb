module FromHash
  def from_hash(ops)
    ops.each do |k,v|
      send("#{k}=",v)
    end
    self
  end
  def initialize(ops={})
    from_hash(ops)
  end
end

class Class
  def self.from_hash(ops={})
    res = new
    res.from_hash(ops)
    res
  end
end