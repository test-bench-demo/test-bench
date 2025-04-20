module TestBench
  module Test
    module Automated
      class Run
        class Summary
          include Telemetry::Sink::Handler
          include ImportConstants

          import_constants Session::Events

          def writer
            @writer ||= Output::Writer::Substitute.build
          end
          attr_writer :writer

          def status
            @status ||= Session::Status.initial
          end
          attr_writer :status

          def file_totals
            @file_totals ||= FileTotals.initial
          end
          attr_writer :file_totals

          def files
            @files ||= {}
          end
          attr_writer :files

          def file_stack
            @file_stack ||= FileStack.new
          end

          attr_accessor :start_time

          def self.build(styling: nil, device: nil)
            instance = new

            instance.start_time = ::Time.now

            Output::Writer.configure(instance, styling:, device:)

            instance
          end

          def self.configure(receiver, styling: nil, device: nil, attr_name: nil)
            attr_name ||= :summary

            instance = build(styling:, device:)
            receiver.public_send(:"#{attr_name}=", instance)
          end

          handle Failed do |failed|
            status.update(failed)

            if current_file?
              current_file.update(failed)
            end
          end

          handle Aborted do |aborted|
            status.update(aborted)

            if current_file?
              current_file.update(aborted)
            end
          end

          handle Skipped do |skipped|
            status.update(skipped)

            if current_file?
              current_file.update(skipped)
            end
          end

          handle TestFinished do |test_finished|
            status.update(test_finished)

            if current_file?
              current_file.update(test_finished)
            end
          end

          handle FileQueued do |file_queued|
            file_totals.record_file_queued

            path = file_queued.file

            file_info = FileInfo.initial(path)
            add_file(file_info)

            file_stack.push(path)
          end

          handle FileExecuted do |file_executed|
            result = file_executed.result

            case result
            when Session::Result.aborted
              file_totals.record_file_aborted
            else
              file_totals.record_file_completed

              if result == Session::Result.passed
                file_path = file_executed.file
                files.delete(file_path)
              end
            end

            file_stack.pop
          end

          handle FileNotFound do |file_not_found|
            file_totals.record_file_not_found

            path = file_not_found.file

            file_info = FileInfo.not_found(path)
            add_file(file_info)

            status.update(file_not_found)
          end

          def print(finish_time=nil)
            finish_time ||= ::Time.now

            if not start_time.nil?
              elapsed_time = finish_time - start_time
            else
              elapsed_time = 0.0
            end

            tests_per_second = status.test_sequence / elapsed_time

            if files.any?
              none_failed = files.each_value.none?(&:failed?)

              if writer.styling?
                writer.
                  style(:bold, :underline)

                if not none_failed
                  writer.style(:red)
                end
              end

              writer.puts("File Summary")

              if not writer.styling?
                writer.puts("- - -")
              end

              files.each_value do |file_info|
                if file_info.failed?
                  writer.style(:red)
                end

                writer.
                  style(:faint).
                  print('-').
                  style(:reset_intensity).
                  print(' ').
                  style(:bold).
                  print(file_info.file_path).
                  style(:reset_intensity).
                  print(': ')

                separator = false

                if file_info.not_found?
                  writer.
                    puts('file not found').
                    puts

                  next
                end

                if not file_info.tests?
                  if not file_info.failed?
                    writer.style(:faint, :italic)
                  end

                  writer.print('no tests')

                  if not file_info.failed?
                    writer.style(:reset_italic, :reset_intensity)
                  end

                  separator = true
                end

                if file_info.failures?
                  writer.print(', ') if separator
                  writer.print(file_info.failures)

                  separator = true
                end

                if file_info.skipped?
                  writer.print(', ') if separator

                  if not file_info.failed?
                    writer.style(:bold, :yellow)
                  end

                  writer.print(file_info.skipped)

                  separator = true
                end

                if file_info.errors?
                  writer.print(', ') if separator

                  writer.print(file_info.errors)

                  separator = true
                end

                writer.puts

                writer.increase_indentation

                file_info.error_messages.each do |error|
                  writer.
                    indent.
                    style(:red).
                    puts(error)
                end

                writer.decrease_indentation

                writer.puts
              end
            end

            writer.
              print("Attempted %s: %s, " % [file_totals.attempted, file_totals.completed])

            if file_totals.aborted?
              writer.style(:bold, :red)
            end

            writer.print("%s" % file_totals.aborted)

            if file_totals.aborted?
              writer.style(:reset_fg, :reset_intensity)
            end

            writer.print(', ')

            if file_totals.not_found?
              writer.style(:red)
            end

            writer.puts("%s" % file_totals.not_found)

            writer.
              puts("%i test#{'s' if status.test_sequence != 1} in %0.2f seconds (%0.2f tests/sec)" % [status.test_sequence, elapsed_time, tests_per_second])

            if status.test_sequence.zero?
              writer.
                style(:faint, :italic).
                print('0 passed').
                style(:reset_italic, :reset_intensity)

            else
              passed_tests = status.test_sequence - status.failure_sequence

              writer.
                style(:green).
                print("%i passed" % passed_tests).
                style(:reset_fg)
            end

            writer.print(', ')

            if status.failure_sequence.zero?
              writer.print('0 failed')
            else
              writer.
                style(:bold, :red).
                print("%i failed" % status.failure_sequence).
                style(:reset_fg, :reset_intensity)
            end

            writer.print(', ')

            if status.skip_sequence.zero?
              writer.print('0 skipped')
            else
              writer.
                style(:yellow).
                print("%i+ skipped" % status.skip_sequence)
            end

            2.times do
              writer.puts
            end
          end

          def add_file(file_info)
            file_path = file_info.file_path

            files[file_path] = file_info
          end

          def current_file
            current_file_path = file_stack.current_file

            files[current_file_path]
          end

          def current_file?
            file_stack.current_file?
          end

          class FileStack
            def entries
              @entries ||= []
            end
            attr_writer :entries

            def push(file_path)
              entries.push(file_path)
            end

            def pop
              entries.pop
            end

            def current_file?
              !entries.empty?
            end

            def current_file
              entries.last
            end
          end

          FileInfo = Struct.new(:file_path, :status, :error_messages, :not_found) do
            def self.initial(file_path)
              status = Session::Status.initial

              error_messages = []

              instance = new(file_path, status, error_messages)
            end

            def self.not_found(file_path)
              instance = new(file_path)
              instance.not_found = true
              instance
            end

            def update(event)
              status.update(event)

              if event in Aborted => aborted
                message = aborted.message
                self.error_messages << message
              end
            end

            def failed?
              if not_found?
                return true
              end

              case status.result
              when Session::Result.failed, Session::Result.aborted
                true
              else
                false
              end
            end

            def tests?
              status.test_sequence > 0
            end

            def failures?
              status.failure_sequence > 0
            end

            def failures
              failures = status.failure_sequence

              "%i failure#{'s' if failures != 1}" % failures
            end

            def skipped?
              status.skip_sequence > 0
            end

            def skipped
              skipped = status.skip_sequence

              "%i+ skipped" % skipped
            end

            def errors?
              error_messages.any?
            end

            def errors
              errors = error_messages.count

              "%i error#{'s' if errors != 1}:" % errors
            end

            def not_found?
              not_found ? true : false
            end
          end

          FileTotals = Struct.new(:attempted_count, :completed_count, :aborted_count, :not_found_count) do
            def self.initial
              new(0, 0, 0, 0)
            end

            def record_file_queued
              self.attempted_count += 1
            end

            def record_file_completed
              self.completed_count += 1
            end

            def record_file_aborted
              self.aborted_count += 1
            end

            def record_file_not_found
              self.attempted_count += 1
              self.not_found_count += 1
            end

            def attempted
              "%i file#{'s' if attempted_count != 1}" % attempted_count
            end

            def completed
              "%i completed" % completed_count
            end

            def aborted?
              aborted_count > 0
            end

            def aborted
              "%i aborted" % aborted_count
            end

            def not_found?
              not_found_count > 0
            end

            def not_found
              "%i not found" % not_found_count
            end
          end
        end
      end
    end
  end
end
