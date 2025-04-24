module TestBench
  module TestBench
    module Pseudorandom
      module Controls
        module Seed
          def self.example
            '1111111111111111'
          end

          def self.other_example
            '2222222222222222'
          end

          module Value
            def self.example(seed=nil)
              seed ||= Seed.example

              seed.to_i(36)
            end
          end
        end
      end
    end
  end
end
