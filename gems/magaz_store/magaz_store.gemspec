$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "magaz_store/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "magaz_store"
  s.version     = MagazStore::VERSION
  s.authors     = ["Andriy Tyurnikov"]
  s.email       = ["Andriy.Tyurnikov@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of MagazStore."
  s.description = "TODO: Description of MagazStore."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
end
