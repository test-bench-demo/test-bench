module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Event
              def self.example
                Telemetry::Event.example
              end

              def self.event_data
                Telemetry::Event.event_data
              end

              def self.other_example
                Telemetry::Event.other_example
              end

              def self.random
                Telemetry::Event.random
              end

              SomeEvent = Telemetry::Event::SomeEvent

              module Pending
                def self.example
                  SomePendingEvent.new
                end

                SomePendingEvent = Test::Automated::Telemetry::Event.define(:result)
              end
            end
          end
        end
      end
    end
  end
end
