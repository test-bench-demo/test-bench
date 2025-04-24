module TestBench
  require 'test_bench/test/automated/session/controls'

  require 'test_bench/test/automated/output/controls/session'

  require 'test_bench/test/automated/output/controls/random'
  require 'test_bench/test/automated/output/controls/status'
  require 'test_bench/test/automated/output/controls/text'

  require 'test_bench/test/automated/output/controls/style'

  require 'test_bench/test/automated/output/controls/comment_style'

  require 'test_bench/test/automated/output/controls/events/failed'
  require 'test_bench/test/automated/output/controls/events/aborted'
  require 'test_bench/test/automated/output/controls/events/skipped'
  require 'test_bench/test/automated/output/controls/events/commented'
  require 'test_bench/test/automated/output/controls/events/detailed'
  require 'test_bench/test/automated/output/controls/events/test_started'
  require 'test_bench/test/automated/output/controls/events/test_finished'
  require 'test_bench/test/automated/output/controls/events/context_started'
  require 'test_bench/test/automated/output/controls/events/context_finished'
  require 'test_bench/test/automated/output/controls/events/file_queued'
  require 'test_bench/test/automated/output/controls/events/file_executed'
  require 'test_bench/test/automated/output/controls/events/file_not_found'

  require 'test_bench/test/automated/output/controls/event'
end
