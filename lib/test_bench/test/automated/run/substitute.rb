module TestBench
  module Test
    module Automated
      class Run
        module Substitute
          def self.build
            Run.new
          end

          class Run
            attr_accessor :result
            alias :set_result :result=

            attr_accessor :ran
            def ran?
              ran ? true : false
            end

            def paths
              @paths ||= []
            end

            def call(&block)
              block.(self)

              result
            end

            def path(path)
              self.ran = true

              paths << path
            end
            alias :<< :path

            def path?(path)
              paths.include?(path)
            end
          end
        end
      end
    end
  end
end
