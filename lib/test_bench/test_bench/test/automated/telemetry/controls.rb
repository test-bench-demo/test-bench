module TestBench
  require 'tempfile'

  require 'test_bench/pseudorandom/controls'

  require 'test_bench/test/automated/telemetry/controls/random'

  require 'test_bench/test/automated/telemetry/controls/process_id'
  require 'test_bench/test/automated/telemetry/controls/time'

  require 'test_bench/test/automated/telemetry/controls/path/file'

  require 'test_bench/test/automated/telemetry/controls/event_data'

  require 'test_bench/test/automated/telemetry/controls/event'
  require 'test_bench/test/automated/telemetry/controls/event/metadata'

  require 'test_bench/test/automated/telemetry/controls/sink'
  require 'test_bench/test/automated/telemetry/controls/handler'
end
