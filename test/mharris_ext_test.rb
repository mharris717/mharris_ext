require_relative 'test_helper'

class MharrisExtTest < Minitest::Test
  def test_loads_without_facets_and_preserves_builtin_file_write
    out, err = run_ruby(<<~RUBY)
      original = File.method(:write)
      require 'mharris_ext'
      raise 'Facets loaded' if $LOADED_FEATURES.any? { |x| x.include?('/facets/') }
      raise 'File.write replaced' unless File.method(:write) == original
      puts 'loaded'
    RUBY
    assert_equal "loaded\n", out
    assert_empty err
  end

  def test_fattr_is_still_available
    klass = Class.new { fattr(:answer) { 42 } }
    assert_equal 42, klass.new.answer
  end
end
