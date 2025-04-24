module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Message
              def self.example
                "Some message"
              end

              module Failure
                def self.example
                  "Some failure"
                end

                def self.other_example
                  "Some other failure"
                end
              end

              module Error
                def self.example
                  Exception::Message.example
                end

                def self.other_example
                  Exception::Message.other_example
                end
              end

              module Skip
                def self.example
                  "Some skipped test or context"
                end

                def self.other_example
                  "Some other skipped test or context"
                end
              end
            end
          end
        end
      end
    end
  end
end
