require_relative 'lib/warden/ory_kratos/version'

Gem::Specification.new do |gem|
  gem.name = 'warden-ory-kratos'
  gem.authors = ['ScoreVision', 'Zach Norris']
  gem.email = ['support@scorevision.com', 'znorris+gems@gmail.com']
  gem.license = 'MIT'

  gem.description = 'Ory Kratos strategies for Warden. Strategies include Kratos native sessions, and JWT support for Ory proxy.'
  gem.summary = 'Ory Kratos strategies for Warden.'
  gem.homepage = 'https://github.com/ScoreVision/warden-ory-kratos'
  gem.version = Warden::OryKratos::VERSION

  gem.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.add_dependency 'warden'
  gem.add_dependency 'jwt'
  gem.add_dependency 'open-uri'
  gem.add_development_dependency 'rake'
end
