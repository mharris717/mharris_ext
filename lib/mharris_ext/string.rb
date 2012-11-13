class String
  def rpad(n,pad_char=" ")
    return self if length >= n
    pad = pad_char * (n-length)
    self + pad
  end
  def lpad(n,pad_char=" ")
    return self if length >= n
    pad = pad_char * (n-length)
    pad + self
  end
end

class Numeric
  def lpad(n,pad_char="0")
    to_s.lpad(n,pad_char)
  end
end