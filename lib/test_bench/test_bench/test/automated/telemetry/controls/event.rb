module TestBench
  module TestBench
    module Test
      module Automated
        class Telemetry
          module Controls
            module Event
              def self.example(some_attribute: nil, some_other_attribute: nil, event_class: nil, metadata: nil, process_id: nil, time: nil)
                some_attribute ||= self.some_attribute
                some_other_attribute ||= self.some_other_attribute

                metadata ||= Metadata.example(process_id:, time:)
                event_class ||= SomeEvent

                event = event_class.new
                event.some_attribute = some_attribute
                event.some_other_attribute = some_other_attribute
                event.metadata = metadata
                event
              end

              def self.event_data
                event = self.example
                Telemetry::Event::Export.(event)
              end

              def self.other_example
                Other.example
              end

              def self.random
                Random.example(event_class:)
              end

              def self.event_class
                SomeEvent
              end

              def self.some_attribute
                'some-value'
              end

              def self.some_other_attribute
                'some-alternate-value'
              end

              def self.process_id
                EventData.process_id
              end

              def self.time
                EventData.time
              end

              SomeEvent = Telemetry::Event.define(
                :some_attribute,
                :some_other_attribute
              )

              SomeOtherEvent = Telemetry::Event.define(
                :some_attribute,
                :some_other_attribute
              )

              module Other
                def self.example(some_attribute: nil, some_other_attribute: nil, metadata: nil, process_id: nil, time: nil)
                  some_attribute ||= self.some_attribute
                  some_other_attribute ||= self.some_other_attribute
                  metadata ||= Metadata::Other.example(process_id:, time:)

                  Event.example(some_attribute:, some_other_attribute:, event_class:, metadata:)
                end

                def self.event_class
                  SomeOtherEvent
                end

                def self.some_attribute
                  'some-other-value'
                end

                def self.some_other_attribute
                  'some-other-alternate-value'
                end

                def self.event_data
                  event = self.example
                  Telemetry::Event::Export.(event)
                end
              end

              module Random
                def self.example(some_attribute: nil, some_other_attribute: nil, event_class: nil, metadata: nil, process_id: nil, time: nil)
                  some_attribute ||= self.some_attribute
                  some_other_attribute ||= self.some_other_attribute
                  event_class ||= self.event_class
                  metadata ||= Metadata::Random.example(process_id:, time:)

                  Event.example(some_attribute:, some_other_attribute:, event_class:, metadata:)
                end

                def self.event_class
                  if Controls::Random.boolean
                    SomeEvent
                  else
                    SomeOtherEvent
                  end
                end

                def self.some_attribute
                  suffix = Controls::Random.string

                  "#{Event.some_attribute}-#{suffix}"
                end

                def self.some_other_attribute
                  suffix = Controls::Random.string

                  "#{Event.some_other_attribute}-#{suffix}"
                end

                def self.event_data
                  event = self.example
                  Telemetry::Event::Export.(event)
                end
              end

              module Data
                def self.example
                  some_attribute = Event.some_attribute
                  some_other_attribute = Event.some_other_attribute

                  [some_attribute, some_other_attribute]
                end

                module Other
                  def self.example
                    some_attribute = Event::Other.some_attribute
                    some_other_attribute = Event::Other.some_other_attribute

                    [some_attribute, some_other_attribute]
                  end
                end

                module Random
                  def self.example
                    some_attribute = Event::Random.some_attribute
                    some_other_attribute = Event::Random.some_other_attribute

                    [some_attribute, some_other_attribute]
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
