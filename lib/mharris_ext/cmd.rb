def has_bundler?
  !!defined?(Bundler)
end

module MharrisExt
  def self.ec(cmd,ops = {})
    puts cmd unless ops[:silent]
    run = proc do
      res = `#{cmd}`
      [res, $?]
    end
    res, status = if has_bundler?
      Bundler.with_unbundled_env(&run)
    else
      run.call
    end
    raise "bad cmd #{status.to_i} #{cmd} #{res}" unless status.success?
    puts res unless ops[:silent]
    res
  end
end

def ec(*args)
  MharrisExt.ec(*args)
end
