RELEASE_VERSION = case
  #Builds of pull requests
  when !(ENV['TRAVIS_PULL_REQUEST'] || 'false').match(/false/i) then "0.#{ENV['TRAVIS_PULL_REQUEST']}"
  #Builds of branches that aren't master or release
  when !ENV['TRAVIS_BRANCH'] || !ENV['TRAVIS_BRANCH'].match(/^release[\/-]/i) then '0.0'
  #Builds of release branches (or locally or on server)
  else ENV['TRAVIS_BRANCH'].match(/^release[\/-](\d+\.\d+)$/i)[1]
end
VERSION = Gem::Version.new("#{RELEASE_VERSION}.#{ENV['TRAVIS_BUILD_NUMBER'] || '0'}.0")

Gem::Specification.new() do |s|
  s.name = 'osiris'
  s.version = VERSION.to_s
  s.platform = Gem::Platform::RUBY
  s.authors = ['Warren Parad']
  s.license = 'BSD-3-Clause'
  s.email = ["wparad@gmail.com"]
  s.homepage = 'https://github.com/wparad/Osiris'
  s.summary = 'A lightweight s3 builder and code deployment tool wrapper'
  s.description = "Osiris is a ruby library to interact with AWS Code Deploy."
  s.files = Dir.glob("{bin,lib}/{**}/{*}", File::FNM_DOTMATCH).select{|f| !(File.basename(f)).match(/^\.+$/)}
  #s.executables = [EXECUTABLE_NAME]
  #s.requirements << 'none'
  s.require_paths = ['lib']
  s.add_runtime_dependency('bundler', '~> 1.10')
  s.add_runtime_dependency('rest-client', '~>1.8')
  s.add_runtime_dependency('rubyzip', '~> 1.1')
  s.add_runtime_dependency('aws-sdk', '~> 2')
end
