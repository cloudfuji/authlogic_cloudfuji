# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Akash Manohar J"]
  gem.email         = ["akash@akash.im"]
  gem.description   = %q{Bushido support for Authlogic}
  gem.summary       = %q{Bushido support for Authlogic}
  gem.homepage      = "http://github.com/Bushido/authlogic_bushido"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "authlogic_bushido"
  gem.require_paths = ["lib"]
  gem.version       = "0.9"

  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'sqlite3'
  gem.add_dependency 'rails'
  gem.add_dependency 'rubycas-client', '2.2.1'
  gem.add_dependency 'authlogic'
end
