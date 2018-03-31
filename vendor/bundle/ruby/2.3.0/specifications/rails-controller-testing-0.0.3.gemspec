# -*- encoding: utf-8 -*-
# stub: rails-controller-testing 0.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "rails-controller-testing".freeze
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Alan Guo Xiang Tan".freeze]
  s.date = "2015-05-28"
  s.email = ["tgx_world@hotmail.com".freeze]
  s.homepage = "https://github.com/tgxworld/rails-controller-testing".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.10".freeze
  s.summary = "Extracting `assigns` and `assert_template` from ActionDispatch.".freeze

  s.installed_by_version = "2.6.10" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, [">= 4.2"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rails>.freeze, [">= 4.2"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, [">= 4.2"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
  end
end
