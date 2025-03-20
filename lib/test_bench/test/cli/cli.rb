module TestBench
  module Test
    class CLI
      ArgumentError = Class.new(RuntimeError)

      attr_reader :arguments

      attr_accessor :immediate_exit_code

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

      def stdin
        @stdin ||= STDIN
      end
      attr_writer :stdin

      def writer
        @writer ||= Output::Writer::Substitute.build
      end
      attr_writer :writer

      def run
        @run ||= Run::Substitute.build
      end
      attr_writer :run

      def random_generator
        @random_generator ||= Pseudorandom::Generator.build
      end
      attr_writer :random_generator

      def require_passing_test
        instance_variable_defined?(:@require_passing_test) ?
          @require_passing_test :
          @require_passing_test = Defaults.require_passing_test
      end
      attr_writer :require_passing_test
      alias :require_passing_test? :require_passing_test

      def initialize(*arguments)
        @arguments = arguments
      end

      def self.build(arguments=nil, env: nil)
        arguments ||= ::ARGV
        env ||= ::ENV

        instance = new(*arguments)

        instance.env = env

        Output::Writer.configure(instance)
        Pseudorandom::Generator.configure(instance)

        Run.configure(instance)

        run = instance.run
        session = run.session
        Parallel::Isolate.configure(run, session:)

        instance
      end

      def self.call(arguments=nil, env: nil)
        instance = build(arguments, env:)

        session = instance.run.session
        Session.instance = session

        exit_code = instance.()

        exit(exit_code)
      end

      def call
        parse_arguments

        if immediate_exit_code?
          return immediate_exit_code
        end

        writer.puts(RUBY_DESCRIPTION)
        writer.puts("Random Seed: #{random_generator.seed}")
        writer.puts

        default_path = Defaults.path

        result = run.! do |run|
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

        exit_code(result)
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

            self.immediate_exit_code = 0

          when '-v', '--version'
            writer.puts "TestBench Version: #{version}"

            self.immediate_exit_code = 0

          when '-d', '--detail', '--no-detail'
            if not negated?(switch)
              detail_policy_text = 'on'
            else
              detail_policy_text = 'off'
            end

            detail_policy = detail_policy_text.to_sym
            Session::Output::Detail.assure_detail(detail_policy)

            env['TEST_DETAIL'] = detail_policy_text

          when '-x', '--exclude', '--no-exclude'
            if not negated?(switch)
              exclude_pattern_text = switch_value!(argument_index, switch)

              if env.key?('TEST_EXCLUDE_FILE_PATTERN')
                exclude_pattern_text = [
                  env['TEST_EXCLUDE_FILE_PATTERN'],
                  exclude_pattern_text
                ].join(':')
              end
            else
              exclude_pattern_text = ''
            end

            env['TEST_EXCLUDE_FILE_PATTERN'] = exclude_pattern_text

          when '-f', '-F', '--only-failure', '--no-only-failure'
            if not negated?(switch)
              only_failure_text = 'on'
            else
              only_failure_text = 'off'
            end

            env['TEST_OUTPUT_ONLY_FAILURE'] = only_failure_text

          when '-o', '--output-styling'
            output_styling_text = switch_value(argument_index) do
              'on'
            end

            output_styling = output_styling_text.to_sym
            Output::Writer::Styling.assure_styling(output_styling)

            env['TEST_OUTPUT_STYLING'] = output_styling_text

          when '-j', '--parallel-processes'
            parallel_processes_text = switch_value(argument_index) do
              require 'etc'
              Etc.nprocessors.to_s
            end

            parallel_processes = Integer(parallel_processes_text)

            env['TEST_PARALLEL_PROCESSES'] = parallel_processes.to_s

          when '-p', '-P', '--require-passing-test', '--no-require-passing-test'
            if not negated?(switch)
              require_passing_tests = 'on'
            else
              require_passing_tests = 'off'
            end

            env['TEST_CLI_REQUIRE_PASSING_TEST'] = require_passing_tests

          when '-s', '--seed'
            seed_text = switch_value!(argument_index, switch)

            begin
              Integer(seed_text)
            rescue
              raise ArgumentError, "Seed switch must be an integer (Seed: #{seed_text.inspect})"
            end

            env['TEST_SEED'] = seed_text

          when '-r', '--require'
            library = switch_value!(argument_index, switch)

            require library

          else
            raise ArgumentError, "Unknown switch #{switch.inspect}"
          end
        end
      end

      def print_help_text
        writer.write <<~TEXT
        Usage: #{program_name} [options] [paths]

        Informational Options:
        \t-h, --help                   Print this help message and exit successfully
        \t-v, --version                Print version and exit successfully

        Configuration Options:
        \t-d, --[no]detail             Always show (or hide) details (Default: #{Session::Output::Detail.default})
        \t-x, --[no-]exclude PATTERN   Do not execute test files matching PATTERN (Default: #{Run::SelectFiles::Defaults.exclude_patterns.inspect})
        \t-f, --[no-]only-failure      Don't display output for test files that pass (Default: #{Run::Output::File::Defaults.only_failure ? 'on' : 'off'})
        \t-o, --output-styling [on|off|detect]
        \t                             Render output coloring and font styling escape codes (Default: #{Output::Writer::Styling.default})
        \t-j, --parallel-jobs [NUMBER]
                                       Run tests in parallel across NUMBER processes (Default: #{Parallel::Isolate::Defaults.parallel_processes})"
        \t-p, --[no-]passing-test      Requires at least one passing test in order to exit successfully (Default: #{Defaults.require_passing_test ? 'on' : 'off'})
        \t-s, --seed NUMBER            Sets pseudo-random number seed (Default: not set)

        Other Options:
        \t-r, --require LIBRARY        Require LIBRARY before running any files

        Paths to test files (and directories containing test files) can be given after any command line arguments or via STDIN (or both).

        If no paths are given, a default path (#{Defaults.path}) is scanned for test files.

        The following environment variables can also control execution:

        \tTEST_DETAIL                  Same as -d or --detail
        \tTEST_EXCLUDE_FILE_PATTERN    Same as -x or --exclude-file-pattern
        \tTEST_OUTPUT_ONLY_FAILURE     Same as -f or --only-failure
        \tTEST_OUTPUT_STYLING          Same as -o or --output-styling
        \tTEST_PARALLEL_PROCESSES      Same as -j or --parallel-jobs
        \tTEST_REQUIRE_PASSING_TEST    Same as -p or --passing-test
        \tTEST_SEED                    Same as -s or --seed

        TEXT
      end

      def negated?(switch)
        if switch.start_with?('--')
          switch.start_with?('--no-')
        else
          /^-[A-Z]/.match?(switch)
        end
      end

      def exit_code(result)
        if result == true
          0
        elsif result == false
          1
        elsif require_passing_test?
          2
        else
          0
        end
      end

      def immediate_exit_code?
        !immediate_exit_code.nil?
      end

      def switch_value!(argument_index, argument)
        switch_value(argument_index) do
          raise ArgumentError, "Argument #{argument.inspect} requires an argument"
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
    end
  end
end
