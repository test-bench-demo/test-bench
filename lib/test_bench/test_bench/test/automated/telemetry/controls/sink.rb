module TestBench
  module TestBench
    module Test
      module Automated
        class Telemetry
          module Controls
            module Sink
              def self.example
                Example.new
              end

              def self.other_example
                OtherExample.new
              end

              class Example
                include Telemetry::Sink

                attr_accessor :received_event_data

                def receive(event_data)
                  self.received_event_data = event_data
                end

                def received?(event_data)
                  self.received_event_data == event_data
                end
              end

              class OtherExample
                include Telemetry::Sink
              end
            end
          end
        end
      end
    end
  end
end
