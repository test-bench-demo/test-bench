module TestBench
  module Test
    module Automated
      class Run
        class Summary
          module Substitute
            def self.build
              Summary.new
            end

            class Summary < Summary
              def printed?(...)
                writer.written?(...)
              end
            end
          end
        end
      end
    end
  end
end
