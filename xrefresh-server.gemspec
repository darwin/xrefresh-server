# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{xrefresh-server}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Antonin Hildebrand"]
  s.date = %q{2009-05-26}
  s.default_executable = %q{xrefresh-server}
  s.description = %q{XRefresh is browser refresh automation for web developers}
  s.email = %q{antonin@hildebrand.cz}
  s.executables = ["xrefresh-server"]
  s.files = [
    "VERSION",
     "bin/xrefresh-server",
     "lib/xrefresh-server.rb",
     "lib/xrefresh-server/client.rb",
     "lib/xrefresh-server/client.rb",
     "lib/xrefresh-server/monitor.rb",
     "lib/xrefresh-server/monitor.rb",
     "lib/xrefresh-server/server.rb",
     "lib/xrefresh-server/server.rb",
     "license.txt",
     "readme.md"
  ]
  s.homepage = %q{http://github.com/darwin/xrefresh-server}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{xrefresh-server}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{XRefresh filesystem monitor for OSX}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
  end
end
