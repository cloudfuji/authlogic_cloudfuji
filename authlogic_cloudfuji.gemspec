# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Sean Grove", "Akash Manohar J"]
  gem.email         = ["sean@cloudfuji.com", "akash@akash.im"]
  gem.description   = %q{Cloudfuji support for Authlogic}
  gem.summary       = %q{Cloudfuji support for Authlogic}
  gem.homepage      = "http://github.com/Cloudfuji/authlogic_cloudfuji"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "authlogic_cloudfuji"
  gem.require_paths = ["lib"]
  gem.version       = "0.9.4"

  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'rails', '>= 3.2.1'
  gem.add_dependency 'rubycas-client', '2.2.1'
  gem.add_dependency 'authlogic'
end
