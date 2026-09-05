require_relative 'test_helper'

class CollectionsTest < Minitest::Test
  def test_integer_of_returns_fresh_results
    rows = 3.of { [] }
    assert_equal [[], [], []], rows
    assert_equal 3, rows.map(&:object_id).uniq.size
    assert_equal [], 0.of { flunk }
  end

  def test_partition_distribution_and_legacy_alias
    assert_equal [[1, 2], [3, 4], [5, 6]], (1..6).to_a.nths(3)
    assert_equal [[1, 2], [3, 4, 5], [6, 7]], (1..7).to_a.nths(3)
    assert_equal [[], [1], [], [2], []], [1, 2].nths(5)
    assert_equal [[], [], []], [].nths(3)
    expected = {0 => [1, 2], 1 => [3, 4, 5], 2 => [6, 7]}
    assert_equal expected, (1..7).to_a.nths_hash(3)
    assert_equal expected, (1..7).to_a.nths_hashx(3)
  end

  def test_partitions_any_enumerable_without_losing_elements
    assert_equal [[1, 2], [3, 4, 5], [6, 7]], (1..7).nths(3)
    (1..17).each do |n|
      parts = (1..31).each.nths(n)
      assert_equal n, parts.size
      assert_equal (1..31).to_a, parts.flatten
      assert_operator parts.map(&:size).max - parts.map(&:size).min, :<=, 1
    end
  end

  def test_invalid_partition_counts_are_rejected
    [0, -1, 1.5, '2', nil].each do |n|
      assert_raises(ArgumentError) { [1, 2].nths(n) }
    end
  end

  def test_aggregation_and_hash_mapping
    assert_equal 6, [1, 2, 3].sumx
    assert_equal 14, [1, 2, 3].sum_b { |x| x * x }
    assert_in_delta 14.0 / 3, [1, 2, 3].avg_b { |x| x * x }
    assert_equal({a: 2, b: 4}, {a: 1, b: 2}.map_value { |x| x * 2 })
  end
end

class ObjectHelpersTest < Minitest::Test
  def test_from_hash_initialization_updates_and_factory
    klass = Class.new do
      include FromHash
      attr_accessor :name, :active
    end
    x = klass.new(name: 'one', active: false)
    assert_equal 'one', x.name
    assert_equal false, x.active
    assert_same x, x.from_hash('name' => 'two')
    assert_equal 'two', x.name
    assert_equal 'three', klass.from_hash(name: 'three').name
    assert_raises(NoMethodError) { klass.new(unknown: 1) }
  end

  def test_non_nil_accessor_accepts_false
    klass = Class.new { attr_accessor_nn :value }
    x = klass.new
    assert_raises(RuntimeError) { x.value }
    x.value = false
    assert_equal false, x.value
    x.value = 0
    assert_equal 0, x.value
    x.value = nil
    assert_raises(RuntimeError) { x.value }
  end

  def test_blank_and_present_without_active_support
    [nil, false, '', '  ', "\u2003", [], {}].each do |x|
      assert x.blank?, "#{x.inspect} should be blank"
      refute x.present?
    end
    [true, 0, '0', [nil], {a: nil}, Object.new].each do |x|
      refute x.blank?, "#{x.inspect} should be present"
      assert x.present?
    end
    x = Object.new
    def x.empty?; true; end
    assert x.blank?
  end

  def test_preserves_ruby_tap
    out, = run_ruby(<<~RUBY)
      before = Object.instance_method(:tap)
      require 'mharris_ext'
      raise 'tap was replaced' unless Object.instance_method(:tap) == before
      x = Object.new
      raise unless x.tap { |v| raise unless v.equal?(x) }.equal?(x)
      puts 'native tap'
    RUBY
    assert_equal "native tap\n", out
  end

  def test_active_support_load_order
    [true, false].each do |rails_first|
      code = <<~RUBY
        require 'active_support/core_ext/object/blank' if #{rails_first}
        before = Object.instance_method(:blank?) if #{rails_first}
        require 'mharris_ext'
        raise 'Active Support blank? replaced' if #{rails_first} && Object.instance_method(:blank?) != before
        require 'active_support/core_ext/object/blank'
        [nil, false, '', '  ', [], {}].each { |x| raise x.inspect unless x.blank? && !x.present? }
        raise unless 0.present?
        puts 'compatible'
      RUBY
      out, = run_ruby(code)
      assert_equal "compatible\n", out
    end
  end

  def test_local_methods
    x = Class.new { def special_helper; end }.new
    assert_includes x.local_methods, :special_helper
  end
end

class FormattingTest < Minitest::Test
  def test_padding_preserves_existing_call_shapes
    assert_equal 'x  ', 'x'.rpad(3)
    assert_equal '  x', 'x'.lpad(3)
    assert_equal 'long', 'long'.rpad(2)
    assert_equal 'x....', 'x'.rpad(3, '..')
    assert_equal '0012', 12.lpad(4)
  end

  def test_commify_signed_and_decimal_numbers
    assert_equal '1,234,567', 1234567.commify
    assert_equal '-123', (-123).commify
    assert_equal '-1,234,567', (-1234567).commify
    assert_equal '1,234.56', '1234.56'.commify
    assert_equal '+1,234.50', '+1234.50'.commify
    assert_equal '12', 12.commify
  end

  def test_regexp_and_time
    pattern = Regexp.escaped('a.b[0]')
    assert_match pattern, 'a.b[0]'
    refute_match pattern, 'axb0'
    assert_equal '09/04 13:02:03', Time.new(2026, 9, 4, 13, 2, 3).short_dt
  end
end

class FileHelpersTest < Minitest::Test
  def test_file_creation_append_and_native_write
    Dir.mktmpdir do |dir|
      file = File.join(dir, 'sample')
      File.create(file, 'first')
      File.append(file, '-last')
      assert_equal 'first-last', File.read(file)
      assert_equal 3, File.write(file, 'new')
      assert_equal 'new', File.read(file)
    end
  end

  def test_path_expansion
    assert_equal ['a', 'a/b', 'a/b/c'], all_dirs_recursive('a/b/c')
    assert_equal ['/a', '/a/b', '/a/b/c'], all_dirs_recursive('/a/b/c')
    assert_raises(RuntimeError) { all_dirs_recursive(nil) }
  end

  def test_directory_helpers_use_supported_ruby_file_apis
    Dir.mktmpdir do |dir|
      target = File.join(dir, 'a', 'b')
      mkdir_recursive(dir: target)
      mkdir_recursive(target)
      assert File.directory?(target)
      source = File.join(dir, 'source.txt')
      File.write(source, 'hello')
      mv_making_dir(source, target)
      assert_equal 'hello', File.read(File.join(target, 'source.txt'))
      rm_r_if(File.join(dir, 'a'))
      refute File.exist?(target)
      rm_r_if(File.join(dir, 'missing'))
    end
  end

  def test_optional_exception_swallowing
    assert_nil eat_exceptions { raise 'expected' }
    assert_equal 42, eat_exceptions { 42 }
  end
end

class CommandHelpersTest < Minitest::Test
  def ruby_command(code)
    Shellwords.join([RbConfig.ruby, '-e', code])
  end

  def test_success_and_silent_output
    out, err = capture_io do
      assert_equal 'ok', ec(ruby_command("print 'ok'"), silent: true)
    end
    assert_empty out
    assert_empty err
  end

  def test_nonzero_exit_reports_failure
    error = assert_raises(RuntimeError) { ec(ruby_command("print 'failure'; exit 7"), silent: true) }
    assert_match(/bad cmd/, error.message)
    assert_match(/failure/, error.message)
  end

  def test_unbundles_child_processes_with_current_bundler
    assert has_bundler?
    assert_equal 'unset', ec(ruby_command("print ENV.fetch('BUNDLE_GEMFILE', 'unset')"), silent: true)
  end

  def test_also_runs_without_bundler
    out, err, status = Bundler.with_unbundled_env do
      Open3.capture3(RbConfig.ruby, '-Ilib', '-e', <<~RUBY)
        require 'mharris_ext'
        raise if has_bundler?
        print ec(#{ruby_command("print 'ok'").inspect}, silent: true)
      RUBY
    end
    assert status.success?, err
    assert_equal 'ok', out
  end
end

class DiagnosticHelpersTest < Minitest::Test
  def test_timing_returns_the_block_result
    out, = capture_io { assert_equal 42, tm('job') { 42 } }
    assert_match(/job took .* seconds/, out)
  end

  def test_backtrace_printing
    out, = capture_io { bt }
    assert_includes out, 'test_backtrace_printing'
  end

  def test_memory_report_thread_can_be_stopped
    x = Object.new
    lines = Queue.new
    x.define_singleton_method(:`) { |_| " 1234\n" }
    x.define_singleton_method(:puts) { |s| lines << s }
    thread = x.send(:print_memory_usage!)
    line = Timeout.timeout(2) { lines.pop }
    assert_match(/Memory: 1234/, line)
  ensure
    thread&.kill
    thread&.join
  end
end
