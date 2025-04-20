module TestBench
  module Test
    module Automated
      class Run
        def summary
          @summary ||= Summary::Substitute.build
        end
        attr_writer :summary

        def select_files
          @select_files ||= SelectFiles::Substitute.build
        end
        attr_writer :select_files

        def session
          @session ||= Session::Substitute.build
        end
        attr_writer :session

        def print_summary
          @print_summary.nil? ?
            @print_summary = true :
            @print_summary
        end
        attr_writer :print_summary
        alias :print_summary? :print_summary

        def abort_on_failure
          @abort_on_failure.nil? ?
            @abort_on_failure = false :
            @abort_on_failure
        end
        attr_writer :abort_on_failure
        alias :abort_on_failure? :abort_on_failure

        def path_sequence
          @path_sequence ||= 0
        end
        attr_writer :path_sequence

        def self.build(exclude: nil, print_summary: nil, abort_on_failure: nil, session: nil)
          if print_summary.nil?
            print_summary = Defaults.print_summary
          end

          if abort_on_failure.nil?
            abort_on_failure = Defaults.abort_on_failure
          end

          instance = new

          instance.print_summary = print_summary
          instance.abort_on_failure = abort_on_failure

          Session.configure(instance, session:)

          Summary.configure(instance)

          SelectFiles.configure(instance, exclude_patterns: exclude)

          session = instance.session

          Output.register_telemetry_sink(session)

          summary = instance.summary
          session.register_telemetry_sink(summary)

          instance
        end

        def self.configure(receiver, attr_name: nil)
          attr_name ||= :run

          session = establish_session

          instance = build(session:)
          receiver.public_send(:"#{attr_name}=", instance)
        end

        def self.call(path, exclude: nil)
          session = establish_session

          instance = build(exclude:, session:)

          instance.() do
            instance << path
          end
        end

        def self.establish_session
          session = Session.build
          Session.establish(session)
          session
        end

        def call(&block)
          block.(self)

          if print_summary?
            summary.print
          end

          result = session.result
          Session::Result.resolve(result)
        end

        def path(path)
          self.path_sequence += 1

          select_files.(path) do |file_path|
            if abort_on_failure?
              case session.result
              when Session::Result.aborted, Session::Result.failed
                next
              end
            end

            session.execute(file_path)
          end

        rescue SelectFiles::PathNotFoundError
          session.execute(path)
        end
        alias :<< :path

        def ran?
          path_sequence > 0
        end

        module Defaults
          def self.abort_on_failure
            env_abort_on_failure = ENV.fetch('TEST_RUN_ABORT_ON_FAILURE', 'off')

            env_abort_on_failure == 'on'
          end

          def self.print_summary
            env_print_summary = ENV.fetch('TEST_RUN_PRINT_SUMMARY', 'on')

            env_print_summary == 'on'
          end
        end
      end
    end
  end
end
