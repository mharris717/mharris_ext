# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mharris_ext"
  s.version = "1.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mike Harris"]
  s.date = "2012-11-13"
  s.description = "mharris717 utlity methods"
  s.email = "mharris717@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README"
  ]
  s.files = [
    "LICENSE",
    "README",
    "Rakefile",
    "VERSION.yml",
    "features/mharris_ext.feature",
    "features/steps/mharris_ext_steps.rb",
    "features/support/env.rb",
    "lib/mharris_ext.rb",
    "lib/mharris_ext/accessor.rb",
    "lib/mharris_ext/benchmark.rb",
    "lib/mharris_ext/cmd.rb",
    "lib/mharris_ext/enumerable.rb",
    "lib/mharris_ext/file.rb",
    "lib/mharris_ext/fileutils.rb",
    "lib/mharris_ext/from_hash.rb",
    "lib/mharris_ext/gems.rb",
    "lib/mharris_ext/methods.rb",
    "lib/mharris_ext/object.rb",
    "lib/mharris_ext/regexp.rb",
    "lib/mharris_ext/string.rb",
    "lib/mharris_ext/time.rb",
    "mharris_ext.gemspec",
    "test/mharris_ext_test.rb",
    "test/test_helper.rb"
  ]
  s.homepage = "http://github.com/GFunk911/mharris_ext"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "mharris717 utility methods"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fattr>, [">= 0"])
      s.add_runtime_dependency(%q<facets>, [">= 0"])
    else
      s.add_dependency(%q<fattr>, [">= 0"])
      s.add_dependency(%q<facets>, [">= 0"])
    end
  else
    s.add_dependency(%q<fattr>, [">= 0"])
    s.add_dependency(%q<facets>, [">= 0"])
  end
end

