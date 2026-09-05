require_relative 'mharris_ext/gems'
Dir[File.join(__dir__, 'mharris_ext', '*.rb')].sort.each { |x| require x }
