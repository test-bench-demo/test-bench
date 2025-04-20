module TestBench
  module Test
    module Automated
      class Executable
        ArgumentError = Class.new(RuntimeError)

        attr_reader :arguments

        def run
          @run ||= Run::Substitute.build
        end
        attr_writer :run

        def writer
          @writer ||= Output::Writer::Substitute.build
        end
        attr_writer :writer

        def stdin
          @stdin ||= STDIN
        end
        attr_writer :stdin

        def env
          @env ||= {}
        end
        attr_writer :env

        def program_name
          @program_name ||= Defaults.program_name
        end
        attr_writer :program_name

        def version
          @version ||= Defaults.version
        end
        attr_writer :version

        def default_path
          @default_path ||= Defaults.path
        end
        attr_writer :default_path

        def initialize(*arguments)
          @arguments = arguments
        end

        def self.build(arguments=nil, env: nil)
          arguments ||= ::ARGV
          env ||= ::ENV

          instance = new(*arguments)

          instance.env = env

          Output::Writer.configure(instance)
          Run.configure(instance)

          instance
        end

        def self.call(arguments=nil, env: nil)
          instance = build(arguments, env:)
          instance.()
        end

        def call
          parse_arguments

          result = run.() do
            if not stdin.tty?
              until stdin.eof?
                path = stdin.gets(chomp: true)

                next if path.empty?

                run << path
              end
            end

            arguments.each do |path|
              run << path
            end

            if not run.ran?
              run << default_path
            end
          end

          exit_code = result ? 0 : 1
          exit_code
        end

        def parse_arguments
          argument_index = 0

          until argument_index == arguments.count
            next_argument = next_argument(argument_index)

            if not next_argument.start_with?('-')
              argument_index += 1
              next
            end

            switch = next_argument!(argument_index)

            case switch
            when '--'
              break

            when '-h', '--help'
              print_help_text

              exit(true)

            when '-v', '--version'
              writer.puts "TestBench Version: #{version}"

              exit(true)

            when '-a', '--abort-on-failure'
              env['TEST_RUN_ABORT_ON_FAILURE'] = 'on'

            when '-x', '--exclude'
              exclude_pattern = required_switch_value(argument_index, switch)

              env['TEST_RUN_EXCLUDE_FILE_PATTERNS'] = [
                env['TEST_RUN_EXCLUDE_FILE_PATTERNS'],
                exclude_pattern
              ].compact.join(':')
            when '-X', '--no-exclude'
              env['TEST_RUN_EXCLUDE_FILE_PATTERNS'] = ''

            when '-s', '--strict'
              env['TEST_STRICT'] = 'on'
            when '-S', '--no-strict'
              env['TEST_STRICT'] = 'off'

            when '-r', '--require'
              library = required_switch_value(argument_index, switch)

              require(library)
            when '-I', '--include'
              load_path = required_switch_value(argument_index, switch)

              if not $LOAD_PATH.include?(load_path)
                $LOAD_PATH << load_path
              end

            when '-d', '--detail'
              env['TEST_OUTPUT_DETAIL'] = 'on'
            when '-D', '--no-detail'
              env['TEST_OUTPUT_DETAIL'] = 'off'


            when '--device'
              device = required_switch_value(argument_index, switch)

              env['TEST_OUTPUT_DEVICE'] = device

            when '-l', '--output-level'
              output_level = required_switch_value(argument_index, switch)

              env['TEST_OUTPUT_LEVEL'] = output_level
            when '-q', '--quiet'
              env['TEST_OUTPUT_LEVEL'] = 'not-passing'

            when '-o', '--output-styling'
              env['TEST_OUTPUT_STYLING'] = 'on'
            when '-O', '--no-output-styling'
              env['TEST_OUTPUT_STYLING'] = 'off'

            when '--no-summary'
              env['TEST_RUN_PRINT_SUMMARY'] = 'off'

            else
              raise ArgumentError, "Unknown switch #{switch.inspect}"
            end
          end
        end

        def print_help_text
          writer.write <<~TEXT
  Usage: #{program_name} [options] [paths]

  Informational Options:
      Help:
          -h, --help
              Print this help message and exit immediately

      Print Version:
          -v, --version
              Print version information and exit immediately

  Execution Options:
      Abort On Failure:
          -a, --abort-on-failure
              Stops execution if a test fails or a test file aborts

      Exclude File Patterns:
          -x, --exclude PATTERN
              Exclude test files that match PATTERN
              If multiple exclude arguments are supplied, then files that match any will be excluded
          -X, --no-exclude
              Don't exclude any files
          Default: '*_init.rb'

      Strict:
          -s, --strict
              Prohibit skipped tests and contexts, and require at least one test to be performed
          -S, --no-strict
              Relax strictness
          Default: non strict, unless TEST_STRICT is set to 'on'

      Require Library:
          -r, --require LIBRARY
              Require LIBRARY before running any files
          -I, --include DIR
              Add DIR to the load path

  Output Options:
      Detail:
          -d, --detail
              Always show details
          -D, --no-detail
              Never show details
          Default: print details when their surrounding context failed, unless TEST_DETAIL is set to 'on' or 'off'

      Device:
          --device DEVICE
              stderr: redirect output to standard error
              null: don't write any output
          Default: stdout

      Verbosity:
          -l, --output-level LEVEL
              all: print output from every file
              not-passing: print output from files that skip tests and contexts or don't perform any tests
              failure: print output only from files that failed or aborted
              abort: print output only from file that aborted
          -q, --quiet
              Sets output verbosity level to 'not-passing'
          Default: all

      Styling:
          -o, --output-styling
              Enable output text styling
          -O, --no-output-styling
              Disable output text styling
          Default: enabled if the output device is an interactive terminal

      Summary:
          --no-summary
              Don't print summary after running files

  Paths to test files (and directories containing test files) can be given after any command line arguments or via STDIN (or both).

  If no paths are given, the directory '#{default_path}' is scanned for test files.

          TEXT
        end

        def required_switch_value(argument_index, argument_name)
          switch_value(argument_index) do
            raise ArgumentError, "Argument #{argument_name.inspect} requires an argument"
          end
        end

        def switch_value(argument_index, &no_value_action)
          next_value = next_argument(argument_index)

          if next_value.nil? || next_value.start_with?('-')
            switch_value = nil

            return no_value_action.()
          else
            switch_value = next_argument!(argument_index)

            return switch_value
          end
        end

        def next_argument(argument_index)
          arguments[argument_index]
        end

        def next_argument!(argument_index)
          arguments.delete_at(argument_index)
        end

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
  end
end
