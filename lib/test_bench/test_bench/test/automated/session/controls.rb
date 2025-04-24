module TestBench
  require 'test_bench/test/automated/telemetry/controls'

  require 'test_bench/test/automated/session/controls/telemetry'

  require 'test_bench/test/automated/session/controls/event'
  require 'test_bench/test/automated/session/controls/metadata'
  require 'test_bench/test/automated/session/controls/random'
  require 'test_bench/test/automated/session/controls/result'
  require 'test_bench/test/automated/session/controls/sequence'
  require 'test_bench/test/automated/session/controls/status'
  require 'test_bench/test/automated/session/controls/telemetry_sink'

  require 'test_bench/test/automated/session/controls/path'
  require 'test_bench/test/automated/session/controls/path/apex_directory'
  require 'test_bench/test/automated/session/controls/path/file'
  require 'test_bench/test/automated/session/controls/path/file/create'

  require 'test_bench/test/automated/session/controls/exception/raise'
  require 'test_bench/test/automated/session/controls/exception'
  require 'test_bench/test/automated/session/controls/exception/message'

  require 'test_bench/test/automated/session/controls/backtrace'

  require 'test_bench/test/automated/session/controls/text'
  require 'test_bench/test/automated/session/controls/message'
  require 'test_bench/test/automated/session/controls/title'

  require 'test_bench/test/automated/session/controls/comment_disposition'

  require 'test_bench/test/automated/session/controls/events/failed'
  require 'test_bench/test/automated/session/controls/events/aborted'
  require 'test_bench/test/automated/session/controls/events/skipped'
  require 'test_bench/test/automated/session/controls/events/commented'
  require 'test_bench/test/automated/session/controls/events/detailed'
  require 'test_bench/test/automated/session/controls/events/test_started'
  require 'test_bench/test/automated/session/controls/events/test_finished'
  require 'test_bench/test/automated/session/controls/events/context_started'
  require 'test_bench/test/automated/session/controls/events/context_finished'
  require 'test_bench/test/automated/session/controls/events/file_queued'
  require 'test_bench/test/automated/session/controls/events/file_executed'
  require 'test_bench/test/automated/session/controls/events/file_not_found'
  require 'test_bench/test/automated/session/controls/events'
end
