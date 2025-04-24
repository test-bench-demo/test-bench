module TestBench
  module TestBench
    module Test
      module Automated
        class Telemetry
          module Controls
            module Handler
              def self.example
                Example.new
              end

              class Example
                include Telemetry::Sink::Handler

                attr_accessor :handled_event
                attr_accessor :handled_event_data

                handle Event::SomeEvent do |some_event|
                  self.handled_event = some_event
                end

                def handle_event_data(event_data)
                  self.handled_event_data = event_data
                end

                def handled?(event=nil)
                  return false if handled_event.nil?

                  return true if event.nil?

                  event == handled_event
                end

                def handled_event_data?(event_data)
                  self.handled_event_data == event_data
                end
              end

              module NoHandler
                def self.example
                  Example.new
                end

                class Example
                  include Telemetry::Sink::Handler
                end
              end

              module NoArgument
                def self.example
                  Example.new
                end

                class Example
                  include Telemetry::Sink::Handler

                  attr_accessor :handled_event
                  def handled? = !!handled_event

                  handle Event::SomeEvent do
                    self.handled_event = true
                  end
                end
              end

              module Method
                def self.example(event_type=nil)
                  event_type ||= Event::SomeEvent.event_type

                  event_name = Telemetry::Event::EventName.get(event_type)

                  :"handle_#{event_name}"
                end

                def self.other_example
                  event_type = Event::SomeOtherEvent.event_type

                  example(event_type)
                end
              end
            end
          end
        end
      end
    end
  end
end
