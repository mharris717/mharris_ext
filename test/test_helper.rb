require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
  track_files 'lib/**/*.rb'
end
require 'minitest/autorun'
require 'minitest/mock'
require 'open3'
require 'rbconfig'
require 'shellwords'
require 'tmpdir'
require 'timeout'
require 'stringio'

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'mharris_ext'

class Minitest::Test
  def run_ruby(code)
    out, err, status = Open3.capture3(RbConfig.ruby, '-Ilib', '-e', code)
    assert status.success?, "#{out}\n#{err}"
    [out, err]
  end
end
