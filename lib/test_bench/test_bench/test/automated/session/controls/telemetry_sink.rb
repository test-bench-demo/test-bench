module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module TelemetrySink
              def self.example
                Telemetry::Sink.example
              end

              class SetTrace
                include Test::Automated::Telemetry::Sink

                attr_accessor :trace_text

                attr_reader :session

                def initialize(session)
                  @session = session
                end

                def self.register(session)
                  instance = new(session)
                  session.register_telemetry_sink(instance)
                  instance
                end

                def receive(_event_data)
                  trace_text = session.trace.join

                  self.trace_text = trace_text
                end
              end
            end
          end
        end
      end
    end
  end
end
