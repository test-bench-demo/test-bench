module TestBench
  module TestBench
    module Test
      module Automated
        class Telemetry
          module Controls
            module Event
              module Metadata
                def self.example(process_id: nil, time: nil)
                  if process_id == :none
                    process_id = nil
                  else
                    process_id ||= self.process_id
                  end

                  if time == :none
                    time = nil
                  else
                    time ||= self.time
                  end

                  metadata = Telemetry::Event::Metadata.new
                  metadata.process_id = process_id
                  metadata.time = time
                  metadata
                end

                def self.other_example
                  Other.example
                end

                def self.random
                  Random.example
                end

                def self.process_id
                  ProcessID.example
                end

                def self.time
                  Time.example
                end

                module Other
                  def self.example(process_id: nil, time: nil)
                    process_id ||= self.process_id
                    time ||= self.time

                    Metadata.example(process_id:, time:)
                  end

                  def self.process_id
                    ProcessID.other_example
                  end

                  def self.time
                    Time.other_example
                  end
                end

                module Random
                  def self.example(process_id: nil, time: nil)
                    process_id ||= ProcessID.random
                    time ||= Controls::Time.random

                    Metadata.example(process_id:, time:)
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
