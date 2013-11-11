def has_bundler?
  Bundler
  true
rescue => exp
  return false
end

module MharrisExt
  def self.ec(cmd,ops={})
    puts cmd unless ops[:silent]
    res = nil
    if has_bundler?
      Bundler.with_clean_env do
        res = `#{cmd}`
      end
    else
      res = `#{cmd}`
    end

    raise "bad cmd #{$?.to_i} #{cmd} #{res}" unless $?.to_i == 0
    puts res unless ops[:silent]
    res
  end
end

def ec(*args)
  MharrisExt.ec(*args)
end