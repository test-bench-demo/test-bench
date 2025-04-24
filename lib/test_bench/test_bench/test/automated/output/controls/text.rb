module TestBench
  module TestBench
    module Test
      module Automated
        class Output
          module Controls
            module Text
              def self.example
                "Some text"
              end

              def self.other_example
                "Some other text"
              end

              module NewlineTerminated
                def self.example(lines: nil)
                  lines ||= 1

                  line_count = lines

                  lines = (1..line_count).map do |line_number|
                    "Line #{line_number}\n"
                  end

                  lines.join
                end
              end
            end
          end
        end
      end
    end
  end
end
