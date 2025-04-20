require 'test_bench/fixture'

require 'test_bench/test/automated/run'
require 'test_bench/test/automated/executable'

require 'test_bench/test_bench'

[
  "test/automated/run",
  "test/automated/executable"
].each do |original_gem_feature|
  require original_gem_feature
rescue LoadError
  $LOADED_FEATURES.push("#{original_gem_feature}.rb")
end

TestBench::ImportConstants.(TestBench)
