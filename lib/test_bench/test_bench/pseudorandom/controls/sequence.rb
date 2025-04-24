module TestBench
  module TestBench
    module Pseudorandom
      module Controls
        module Sequence
          def self.example(count=nil, random_seed: nil)
            count ||= self.count
            random_seed ||= self.random_seed

            random = ::Random.new(random_seed)

            count.times.map do
              random.bytes(8)
            end
          end

          def self.count
            3
          end

          def self.random_seed
            Seed::Value.example
          end

          module Integer
            def self.example(count=nil, random_seed: nil)
              sequence = Sequence.example(count, random_seed:)

              sequence.map do |bytes|
                bytes.unpack1('Q>')
              end
            end
          end

          module Decimal
            def self.example(count=nil, random_seed: nil)
              sequence = Sequence.example(count, random_seed:)

              sequence.map do |bytes|
                bytes.unpack1('D')
              end
            end
          end

          module String
            def self.example(count=nil, random_seed: nil)
              integer_sequence = Sequence::Integer.example(count, random_seed:)

              integer_sequence.map do |integer|
                integer.to_s(36)
              end
            end
          end

          module Boolean
            def self.example(count=nil, random_seed: nil)
              count ||= 10

              integer_sequence = Sequence::Integer.example(count, random_seed:)

              integer_sequence.map do |integer|
                integer % 2 == 1
              end
            end
          end
        end
      end
    end
  end
end
