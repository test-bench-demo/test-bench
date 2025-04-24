module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Backtrace
              def self.example
                [
                  Exception::Example.backtrace.first,
                  "*omitted*",
                  Exception::Example.backtrace.last
                ]
              end

              def self.pattern
                Pattern.example
              end

              module Pattern
                def self.example
                  '*/some-subdir/*'
                end

                def self.other_example
                  '*/some-other-subdir/*'
                end
              end

              module Styling
                def self.example
                  [
                    Exception::Example.backtrace.first,
                    "\e[2;3m*omitted*\e[23;22m",
                    Exception::Example.backtrace.last
                  ]
                end
              end

              module Cause
                def self.example
                  [
                    Exception::Cause::Example.backtrace.first,
                    "*omitted*",
                    Exception::Cause::Example.backtrace.last
                  ]
                end
              end
            end
          end
        end
      end
    end
  end
end
