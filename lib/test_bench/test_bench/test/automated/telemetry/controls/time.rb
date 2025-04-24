module TestBench
  module TestBench
    module Test
      module Automated
        class Telemetry
          module Controls
            module Time
              def self.example(offset_seconds: nil, offset_milliseconds: nil, offset_nanoseconds: nil)
                offset_nanoseconds ||= 0

                if not offset_seconds.nil?
                  offset_milliseconds = offset_seconds * 1_000
                  return example(offset_milliseconds:)
                elsif not offset_milliseconds.nil?
                  offset_nanoseconds = offset_milliseconds * 1_000_000
                  return example(offset_nanoseconds:)
                end

                nanoseconds = 111_111_111
                seconds = 11
                minutes = 11
                hours = 11
                day = 1
                month = 1
                year = 2000

                nanoseconds += offset_nanoseconds

                remaining_offset_seconds, nanoseconds = nanoseconds.divmod(1_000_000_000)

                microseconds = Rational(nanoseconds, 1_000)

                time = ::Time.utc(year, month, day, hours, minutes, seconds, microseconds)

                time + remaining_offset_seconds
              end

              def self.other_example
                Other.example
              end

              def self.random
                Random.example
              end

              module ISO8601
                def self.example(time=nil, **arguments)
                  time ||= Time.example(**arguments)

                  time.strftime('%Y-%m-%dT%H:%M:%S.%NZ')
                end

                def self.other_example
                  time = Time.other_example

                  example(time)
                end

                def self.random
                  time = Time.random

                  example(time)
                end
              end

              module Offset
                def self.example
                  Time.example(offset_nanoseconds:)
                end

                def self.offset_nanoseconds
                  Elapsed.nanoseconds
                end
              end
              Other = Offset

              module Random
                def self.example
                  offset_nanoseconds = Controls::Random.integer

                  Time.example(offset_nanoseconds:)
                end
              end

              module Elapsed
                def self.example
                  seconds
                end

                def self.nanoseconds
                  111_111_111
                end

                def self.milliseconds
                  111.111_111
                end

                def self.seconds
                  0.111_111_111
                end
              end
            end
          end
        end
      end
    end
  end
end
