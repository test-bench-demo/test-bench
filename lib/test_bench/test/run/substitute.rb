module TestBench
  module Test
    class Run
      module Substitute
        def self.build
          Run.new
        end

        class Run < Run
          def path?(path)
            select_files.path?(path)
          end

          def set_result(result)
            if result
              session.record_assertion
            else
              session.record_failure
            end
          end
        end
      end
    end
  end
end
