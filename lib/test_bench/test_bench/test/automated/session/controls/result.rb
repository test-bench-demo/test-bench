module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Result
              def self.example
                Session::Result.passed
              end

              def self.other_example
                Session::Result.failed
              end
            end
          end
        end
      end
    end
  end
end
