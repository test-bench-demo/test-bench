module TestBench
  module Test
    class Run
      class Isolate
        StateError = Class.new(RuntimeError)

        def session
          @session ||= Session::Substitute.build
        end
        attr_writer :session

        def process_sequence
          @process_sequence ||= 0
        end
        attr_writer :process_sequence

        def file_sequence
          @file_sequence ||= 0
        end
        attr_writer :file_sequence

        def pending_file_sequence
          @pending_file_sequence ||= 0
        end
        attr_writer :pending_file_sequence

        attr_accessor :process_id
        attr_accessor :telemetry_reader
        attr_accessor :path_writer

        def self.build(session: nil)
          instance = new
          Session.configure(instance, session:)
          instance
        end

        def self.configure(receiver, session: nil, attr_name: nil)
          attr_name ||= :isolate

          instance = build(session:)
          receiver.public_send(:"#{attr_name}=", instance)
        end

        def start
          assure_not_started

          path_reader, path_writer = IO.pipe
          telemetry_reader, telemetry_writer = IO.pipe

          process_id = fork do
            path_writer.close
            telemetry_reader.close

            telemetry_sink = Telemetry::Sink::File.new(telemetry_writer)

            session = Session.build do |telemetry|
              telemetry.register(telemetry_sink)
            end
            Session.instance = session

            while path = path_reader.gets(chomp: true)
              full_path = File.expand_path(path)

              path_found = File.exist?(full_path)
              if not path_found
                session.record_event(Events::FileNotFound.new(path))
                load(full_path) # Raise a LoadError
              end

              Pseudorandom.reset(full_path)

              failure_sequence = session.failure_sequence

              session.record_event(Events::FileStarted.new(path))

              begin
                load(full_path)

              rescue Exception => exception
                error_message = ErrorMessage.get(exception)
                error_text = exception.full_message

                session.record_event(Events::FileTerminated.new(path, error_message, error_text))

                raise exception

              else
                failed = session.failed?(failure_sequence)
                result = !failed

                session.record_event(Events::FileFinished.new(path, result))
              end
            end
          end

          telemetry_writer.close
          path_reader.close

          self.process_id = process_id
          self.telemetry_reader = telemetry_reader
          self.path_writer = path_writer

          self.process_sequence += 1

          process_id
        end

        def synchronize(timeout_milliseconds=nil)
          assure_started

          if not timeout_milliseconds.nil?
            timeout_seconds = timeout_milliseconds / 1_000.0
          end

          wait_time_milliseconds = 0

          until idle?
            event_text = String.new

            read_byte = telemetry_reader.read_nonblock(1, exception: false)

            if read_byte == :wait_readable
              select_files = [telemetry_reader]

              wait_start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

              ready_files, _, _ = IO.select(select_files, [], [], timeout_seconds)
              if ready_files != select_files
                return nil
              end

              wait_stop_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
              wait_time_seconds = wait_stop_time - wait_start_time

              wait_time_milliseconds += wait_time_seconds * 1_000
            else
              event_text << read_byte
            end

            line_text = telemetry_reader.gets
            if line_text.nil?
              break
            end

            event_text << line_text

            event_data = Telemetry::EventData.load(event_text)
            session.record_event(event_data)

            case event_data
            when Events::FileFinished
              self.file_sequence += 1

            when Events::FileTerminated, Events::FileNotFound
              self.file_sequence += 1

              await_exit
              start
            end
          end

          wait_time_milliseconds
        end

        def run(path)
          assure_started

          self.pending_file_sequence += 1

          path_writer.puts(path)

          one_millisecond = 1
          synchronize(one_millisecond)
        end

        def stop
          assure_started

          synchronize

          path_writer.close

          await_exit
        end

        def idle?
          pending_file_sequence == file_sequence
        end

        def await_exit
          process_status = ::Process::Status.wait(process_id)

          self.process_id = nil

          telemetry_reader.close
          path_writer.close

          process_status.exitstatus
        end

        def assure_started
          if process_id.nil?
            raise StateError, "Not started"
          end
        end

        def assure_not_started
          if not process_id.nil?
            raise StateError, "Already started (Process ID: #{process_id.inspect})"
          end
        end

        module ErrorMessage
          def self.get(exception)
            error_message = exception.full_message(order: :top, highlight: false).each_line(chomp: true).first

            root_directory_prefix = File.join(Dir.pwd, '')
            error_message.delete_prefix!(root_directory_prefix)

            error_message
          end
        end
      end
    end
  end
end
