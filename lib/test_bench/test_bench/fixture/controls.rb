require 'test_bench/fixture'

require 'test_bench/test_bench/import_constants/controls'
require 'test_bench/test_bench/pseudorandom/controls'
require 'test_bench/test_bench/test/automated/telemetry/controls'
require 'test_bench/test_bench/test/automated/session/controls'
require 'test_bench/test_bench/test/automated/output/controls'
require 'test_bench/test_bench/test/automated/fixture/controls'

[
  "import_constants/controls",
  "pseudorandom/controls",
  "test/automated/telemetry/controls",
  "test/automated/session/controls",
  "test/automated/output/controls",
  "test/automated/fixture/controls"
].each do |original_gem_feature|
  require original_gem_feature
rescue LoadError
  $LOADED_FEATURES.push("#{original_gem_feature}.rb")
end
