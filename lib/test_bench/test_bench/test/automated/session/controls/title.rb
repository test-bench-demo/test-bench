module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Title
              def self.example
                "Some Title"
              end

              def self.other_example
                "Some Other Title"
              end

              def self.random
                "#{example} #{Random.string}"
              end

              module Context
                def self.example
                  "Some Context"
                end

                def self.other_example
                  "Some Other Context"
                end
              end

              module Test
                def self.example
                  "Some test"
                end

                def self.other_example
                  "Some other test"
                end
              end
            end
          end
        end
      end
    end
  end
end
