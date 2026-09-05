class Integer
  def of
    res = []
    times { res << yield }
    res
  end
end

module Enumerable
  def sumx
    res = 0
    each { |x| res += x }
    res
  end

  def sum_b
    map { |x| yield(x) }.sum
  end

  def avg_b(&b)
    sum_b(&b).to_f / size.to_f
  end

  def nths(num)
    raise ArgumentError, 'number of partitions must be a positive integer' unless num.is_a?(Integer) && num > 0
    items = to_a
    size_per = items.size.fdiv(num)
    Array.new(num) do |i|
      items[(i * size_per).round...((i + 1) * size_per).round]
    end
  end

  def nths_hash(num)
    nths(num).each_with_index.to_h { |x,i| [i,x] }
  end

  alias_method :nths_hashx, :nths_hash
end

class Hash
  def map_value
    res = {}
    each { |k,v| res[k] = yield(v) }
    res
  end
end

class Numeric
  def commify
    to_s.commify
  end
end

class String
  def commify
    if (parts = /\A([+-]?)(\d+)(\.\d+)?\z/.match(self))
      digits = parts[2].reverse.scan(/.{1,3}/).join(',').reverse
      "#{parts[1]}#{digits}#{parts[3]}"
    else
      # Preserve the legacy grouping behavior for nonnumeric strings.
      return self if length <= 3
      self[0...-3].commify + ',' + self[-3..-1]
    end
  end
end
