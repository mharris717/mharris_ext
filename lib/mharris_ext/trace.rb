def bt
  raise 'foo'
rescue => exp
  puts exp.backtrace.join("\n")
end