require 'test_bench/fixture'

require 'test_bench/test/run'
require 'test_bench/test/cli'

require 'test_bench/test_bench'

[
  "test/run",
  "test/cli"
].each do |original_gem_feature|
  require original_gem_feature
rescue LoadError
  $LOADED_FEATURES.push("#{original_gem_feature}.rb")
end

TestBench::ImportConstants.(TestBench)
