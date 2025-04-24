module TestBench
  module TestBench
    module Test
      module Automated
        class Output
          module Controls
            module CommentStyle
              def self.example
                :normal
              end

              def self.disposition
                'normal'
              end

              module Disposition
                def self.example
                  Session::CommentDisposition.example
                end
              end
            end
          end
        end
      end
    end
  end
end
