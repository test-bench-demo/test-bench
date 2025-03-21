module TestBench
  module Test
    class CLI
      module Parallel
        class Isolate
          attr_reader :session
          attr_reader :serial_isolates

          def initialize(session, serial_isolates)
            @session = session
            @serial_isolates = serial_isolates
          end

          def self.build(session, processes: nil)
            processes ||= Defaults.parallel_processes

            serial_isolates = processes.times.map do
              Run::Isolate.build(session:)
            end

            new(session, serial_isolates)
          end

          def self.configure(receiver, session, processes: nil, attr_name: nil)
            attr_name ||= :isolate

            instance = build(session, processes:)
            receiver.public_send(:"#{attr_name}=", instance)
          end

          def start
            serial_isolates.each(&:start)
          end

          def run(path)
            one_hundred_milliseconds = 0.100

            select_readers = serial_isolates.map(&:telemetry_reader)

            loop do
              serial_isolates.each do |isolate|
                if isolate.idle?
                  return isolate.run(path)
                end
              end

              ready_readers, * = IO.select(select_readers, [], [], one_hundred_milliseconds)

              next if ready_readers.nil?

              serial_isolates.each do |isolate|
                telemetry_reader = isolate.telemetry_reader

                if ready_readers.include?(telemetry_reader)
                  isolate.synchronize(0)
                end
              end
            end
          end

          def stop
            serial_isolates.reverse_each(&:stop)
          end

          module Defaults
            def self.parallel_processes
              ENV.fetch('TEST_PARALLEL_PROCESSES', '1').to_i
            end
          end
        end
      end
    end
  end
end
