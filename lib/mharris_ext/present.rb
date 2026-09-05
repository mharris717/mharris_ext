class Object
  unless method_defined?(:blank?)
    def blank?
      if is_a?(String)
        /\A[[:space:]]*\z/.match?(self)
      else
        respond_to?(:empty?) ? !!empty? : !self
      end
    end
  end

  unless method_defined?(:present?)
    def present?
      !blank?
    end
  end
end
