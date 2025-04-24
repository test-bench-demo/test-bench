module TestBench
  module TestBench
    module Test
      module Automated
        class Output
          module Controls
            module Style
              def self.example
                :bold
              end

              def self.code
                '1'
              end

              def self.other_example
                Other.example
              end

              module Other
                def self.example
                  :italic
                end

                def self.code
                  '3'
                end
              end

              module Code
                def self.example
                  Style.code
                end

                def self.other_example
                  Other.code
                end
              end
            end
          end
        end
      end
    end
  end
end
