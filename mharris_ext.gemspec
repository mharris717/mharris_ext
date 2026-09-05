Gem::Specification.new do |s|
  s.name = 'mharris_ext'
  s.version = File.read(File.expand_path('VERSION', __dir__)).strip
  s.summary = 'Mike Harris Ruby utility methods'
  s.description = 'Small Ruby helpers for object initialization, collections, files, and shell commands.'
  s.authors = ['Mike Harris']
  s.email = 'mharris717@gmail.com'
  s.homepage = 'https://github.com/mharris717/mharris_ext'
  s.license = 'MIT'
  s.required_ruby_version = '>= 2.7'
  s.require_paths = ['lib']
  s.files = Dir['lib/**/*.rb', 'test/**/*.rb'] + %w[LICENSE README Rakefile VERSION VERSION.yml Gemfile mharris_ext.gemspec]
  s.metadata = { 'source_code_uri' => s.homepage }
  s.add_dependency 'fattr', '~> 2.4'
  s.add_development_dependency 'bundler', '>= 2.4'
  s.add_development_dependency 'rake', '~> 13.3'
end
