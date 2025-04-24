module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              def self.examples(control_method=nil)
                control_method ||= :example

                [
                  Failed,
                  Aborted,
                  Skipped,
                  Commented,
                  Detailed,
                  TestStarted,
                  TestFinished,
                  ContextStarted,
                  ContextFinished,
                  FileQueued,
                  FileExecuted,
                  FileNotFound
                ].map do |control|

                  control.public_send(control_method)
                end
              end

              def self.other_examples
                examples(:other_example)
              end
            end
          end
        end
      end
    end
  end
end
