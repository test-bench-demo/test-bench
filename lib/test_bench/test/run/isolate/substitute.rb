module TestBench
  module Test
    class Run
      class Isolate
        module Substitute
          def self.build
            Isolate.new
          end

          class Isolate
            attr_accessor :started
            attr_accessor :stopped

            def paths
              @paths ||= []
            end
            attr_writer :paths

            def start
              self.started = true
            end

            def started?
              !!self.started
            end

            def run(path)
              paths << path
            end

            def ran?(path)
              paths.include?(path)
            end

            def stop
              self.stopped = true
            end

            def stopped?
              !!self.stopped
            end
          end
        end
      end
    end
  end
end
