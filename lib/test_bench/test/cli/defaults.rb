module TestBench
  module Test
    class CLI
      module Defaults
        def self.path
          ENV.fetch('TEST_CLI_DEFAULT_PATH', 'test/automated')
        end

        def self.require_passing_test
          ENV.fetch('TEST_CLI_REQUIRE_PASSING_TEST', 'on')
        end

        def self.program_name
          $PROGRAM_NAME || 'bench'
        end

        def self.version
          '(unknown)' # Substitute for published version
        end
      end
    end
  end
end