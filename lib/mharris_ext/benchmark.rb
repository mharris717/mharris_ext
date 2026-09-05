def tm(msg = "Thing")
  t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  res = yield
  seconds = Process.clock_gettime(Process::CLOCK_MONOTONIC) - t
  puts "#{msg} took #{seconds} seconds"
  res
end

def print_memory_usage!
  Thread.new do
    loop do
      mem = `ps -o rss= -p #{Process.pid}`.strip
      puts "Memory: #{mem} #{Time.now}"
      sleep(10)
    end
  end
end
