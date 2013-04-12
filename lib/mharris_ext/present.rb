class Object
  def blank?
    to_s.strip == ''
  end
  def present?
    !blank?
  end
end