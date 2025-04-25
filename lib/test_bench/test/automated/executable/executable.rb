module TestBench
  module Test
    module Automated
      class Executable
        def run
          @run ||= Run::Substitute.build
        end
        attr_writer :run

        def arguments
          @arguments ||= []
        end
        attr_writer :arguments

        def stdin
          @stdin ||= STDIN
        end
        attr_writer :stdin

        def self.build(arguments=nil, env: nil)
          instance = new

          arguments = ParseArguments.(arguments, env:)
          instance.arguments = arguments

          Run.configure(instance)

          instance
        end

        def self.call(arguments=nil, env: nil)
          instance = build(arguments, env:)
          instance.()
        end

        def call
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
              run << Defaults.path
            end
          end

          exit_code = result ? 0 : 1
          exit_code
        end
      end
    end
  end
end
