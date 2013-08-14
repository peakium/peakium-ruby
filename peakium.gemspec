$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'peakium/version'

spec = Gem::Specification.new do |s|
  s.name = 'peakium'
  s.version = Peakium::VERSION
  s.summary = 'Ruby bindings for the Peakium API'
  s.description = 'Peakium allows global, flexible recurring payments.  See https://peakium.com for details.'
  s.authors = ['Dan Schultzer']
  s.email = ['dan@dreamconception.com']
  s.homepage = 'https://github.com/peakium/peakium-api'
  s.license = 'MIT'

  s.add_dependency('rest-client', '~> 1.4')
  s.add_dependency('multi_json', '>= 1.0.4', '< 2')

  s.add_development_dependency('mocha', '~> 0.13.2')
  s.add_development_dependency('shoulda', '~> 3.4.0')
  s.add_development_dependency('test-unit')
  s.add_development_dependency('rake')

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
