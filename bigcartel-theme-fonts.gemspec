# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'bigcartel-theme-fonts'
  spec.version       = '1.3.6'
  spec.authors       = ['Big Cartel']
  spec.email         = ['dev@bigcartel.com']
  spec.description   = %q{A simple class for working with Big Cartel's supported theme fonts.}
  spec.summary       = %q{A simple class for working with Big Cartel's supported theme fonts from the browser and from Google Fonts.}
  spec.homepage      = 'https://github.com/bigcartel/bigcartel-theme-fonts'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.5'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'rr', '~> 1.1'
end
