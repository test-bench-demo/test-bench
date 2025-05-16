module TestBench
  class Executable
    module Defaults
      def self.path
        ENV.fetch('TEST_EXECUTABLE_DEFAULT_PATH', 'test/automated')
      end

      def self.program_name
        $PROGRAM_NAME || 'bench'
      end

      def self.version
        '(not set)'
      end
    end
  end
end
