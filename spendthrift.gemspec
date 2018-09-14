
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spendthrift/version"

Gem::Specification.new do |spec|
  spec.name          = "spendthrift"
  spec.version       = Spendthrift::VERSION
  spec.authors       = ["sabbas"]
  spec.email         = ["syed.k.abbas1988@gmail.com"]

  spec.summary       = ''
  spec.description   = ''
  spec.homepage      = ""
  spec.license       = "MIT"



  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "byebug", "~> 10.0.2"
  spec.add_runtime_dependency "aws-sdk-dynamodb", "~> 1.0.0.rc7"
  spec.add_runtime_dependency "plaid", "~> 6.1.0"

end
