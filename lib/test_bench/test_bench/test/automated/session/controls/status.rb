module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Status
              def self.example
                Relative.example
              end

              module Passed
                def self.example
                  Session::Status.new(
                    test_sequence: Sequence.example,
                    failure_sequence: 0,
                    error_sequence: 0,
                    skip_sequence: 0
                  )
                end
              end

              module Failed
                def self.example
                  Session::Status.new(
                    test_sequence: Sequence.example,
                    failure_sequence: Sequence.example,
                    error_sequence: 0,
                    skip_sequence: 0
                  )
                end
              end

              module None
                def self.example
                  Session::Status.new(
                    test_sequence: 0,
                    failure_sequence: 0,
                    error_sequence: 0,
                    skip_sequence: 0
                  )
                end
              end

              module Aborted
                def self.example
                  Session::Status.new(
                    test_sequence: Sequence.example,
                    failure_sequence: Sequence.example,
                    error_sequence: Sequence.example,
                    skip_sequence: 0
                  )
                end
              end

              module Incomplete
                def self.example
                  Session::Status.new(
                    test_sequence: Sequence.example,
                    failure_sequence: 0,
                    error_sequence: 0,
                    skip_sequence: Sequence.example
                  )
                end
              end

              module Relative
                def self.example
                  Session::Status.new(
                    test_sequence: 1,
                    failure_sequence: 11,
                    error_sequence: 111,
                    skip_sequence: 1111
                  )
                end

                def self.reference
                  Session::Status.new(
                    test_sequence: 0,
                    failure_sequence: 1,
                    error_sequence: 11,
                    skip_sequence: 111
                  )
                end

                def self.result
                  Session::Result.aborted
                end
              end
            end
          end
        end
      end
    end
  end
end
