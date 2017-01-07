require_relative 'uncrypt_nemucod/version'

Gem::Specification.new do |s|
  s.name        = 'uncrypt_nemucod'
  s.version     = UncryptNemucod::VERSION
  s.license     = 'MIT'
  s.summary     = 'A small utility gem to derive and decode files "encrypted" by the Nemucod ransomware.'
  s.author      = 'robacarp'
  s.platform    =  Gem::Platform::RUBY
  s.files       = [
    Dir['uncrypt_nemucod/**/*.rb'],
    Dir['bin/*']
  ].flatten

  s.bindir      = 'bin'
  s.executables << 'uncrypt_nemucod'
end
