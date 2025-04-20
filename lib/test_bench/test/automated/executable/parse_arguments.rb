module TestBench
  module Test
    module Automated
      class Executable
        class ParseArguments
          Error = Class.new(RuntimeError)

          def writer
            @writer ||= Output::Writer::Substitute.build
          end
          attr_writer :writer

          def env
            @env ||= {}
          end
          attr_writer :env

          def non_switch_arguments
            @non_switch_arguments ||= []
          end

          attr_reader :raw_arguments

          def initialize(raw_arguments)
            @raw_arguments = raw_arguments
          end

          def self.build(arguments=nil, env: nil)
            arguments ||= ::ARGV
            env ||= ::ENV

            instance = new(arguments)

            instance.env = env

            Output::Writer.configure(instance)

            instance
          end

          def self.call(arguments=nil, env: nil)
            instance = build(arguments, env:)
            instance.()
          end

          def call
            loop do
              switch = next_switch

              case switch
              when '--', nil
                break

              when '-v', '--version'
                version = Defaults.version
                writer.puts "TestBench Version: #{version}"
                exit(true)

              when '-a', '--abort-on-failure'
                env['TEST_RUN_ABORT_ON_FAILURE'] = 'on'

              when '-x', '--exclude'
                exclude_pattern = require_next_argument(switch)

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
                library = require_next_argument(switch)
                require(library)
              when '-I', '--include'
                load_path = require_next_argument(switch)
                if not $LOAD_PATH.include?(load_path)
                  $LOAD_PATH << load_path
                end

              when '-d', '--detail'
                env['TEST_OUTPUT_DETAIL'] = 'on'
              when '-D', '--no-detail'
                env['TEST_OUTPUT_DETAIL'] = 'off'

              when '--device'
                device = require_next_argument(switch)
                env['TEST_OUTPUT_DEVICE'] = device

              when '-l', '--output-level'
                output_level = require_next_argument(switch)
                env['TEST_OUTPUT_LEVEL'] = output_level
              when '-q', '--quiet'
                env['TEST_OUTPUT_LEVEL'] = 'not-passing'

              when '-o', '--output-styling'
                env['TEST_OUTPUT_STYLING'] = 'on'
              when '-O', '--no-output-styling'
                env['TEST_OUTPUT_STYLING'] = 'off'

              when '--no-summary'
                env['TEST_RUN_PRINT_SUMMARY'] = 'off'

              when '-h', '--help'
                writer.write(<<~TEXT)
  Usage: #{Defaults.program_name} [options] [paths]

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

  If no paths are given, the directory '#{Defaults.path}' is scanned for test files.

  The following environment variables can also control execution:

      TEST_RUN_ABORT_ON_FAILURE        See --abort-on-failure
      TEST_RUN_EXCLUDE_FILE_PATTERNS   See --exclude
      TEST_RUN_PRINT_SUMMARY           See --no-summary
      TEST_STRICT                      See --strict
      TEST_OUTPUT_DETAIL               See --detail
      TEST_OUTPUT_DEVICE               See --device
      TEST_OUTPUT_LEVEL                See --output-level
      TEST_OUTPUT_STYLING              See --output-styling
      TEST_EXECUTABLE_DEFAULT_PATH     Specifies default path

                TEXT
                exit(true)

              else
                raise Error, "Incorrect switch #{switch}"
              end
            end

            remaining_arguments
          end

          def remaining_arguments
            non_switch_arguments + raw_arguments
          end
          alias :arguments :remaining_arguments

          def require_next_argument(switch_text)
            argument = next_argument

            if argument.nil?
              raise Error, "Switch #{switch_text} requires an argument"
            end

            argument
          end

          def next_argument
            next_argument = raw_arguments.shift

            if next_argument.nil?
              nil
            elsif switch?(next_argument)
              raw_arguments.unshift(next_argument)
              nil
            else
              next_argument
            end
          end

          def next_switch
            until raw_arguments.empty?
              argument = raw_arguments.shift

              if switch?(argument)
                return argument
              end

              non_switch_arguments << argument
            end

            nil
          end

          def switch?(argument)
            argument.start_with?('-')
          end
        end
      end
    end
  end
end
