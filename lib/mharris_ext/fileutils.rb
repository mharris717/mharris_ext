require 'fileutils'

def all_dirs_recursive(dir)
  raise "null dir" unless dir
  dir.split("/")[0..-1].inject([]) do |paths,dir|
    last_path = (paths.empty? ? "" : "#{paths[-1]}/")
    paths + ["#{last_path}#{dir}"]
  end.select { |x| x != '' }
end

def mkdir_if(dir)
  FileUtils.mkdir(dir) unless File.exist?(dir)
end

def mkdir_recursive(ops)
  dir = ops.is_a?(Hash) ? ops[:dir] : ops
  all_dirs_recursive(dir).each do |dir|
    mkdir_if(dir)
  end
end

def mv_making_dir(f,new_dir)
  mkdir_recursive(new_dir)
  FileUtils.mv(f,new_dir)
end

def rm_r_if(dir)
  FileUtils.rm_r(dir) if File.exist?(dir)
end

def eat_exceptions
  yield
rescue
end
