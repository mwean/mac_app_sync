
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mac_app_sync/version"

Gem::Specification.new do |spec|
  spec.name          = "mac_app_sync"
  spec.version       = MacAppSync::VERSION
  spec.authors       = ["Matt Wean"]
  spec.email         = ["matthew.wean@gmail.com"]

  spec.summary       = "A CLI tool to back up and restore Mac app settings"
  spec.homepage      = "https://github.com/mwean/mac_app_sync"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
