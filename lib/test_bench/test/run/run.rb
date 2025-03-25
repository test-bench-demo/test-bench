module TestBench
  module Test
    class Run
      Error = Class.new(RuntimeError)

      include Events

      def session
        @session ||= Session::Substitute.build
      end
      attr_writer :session

      def select_files
        @select_files ||= SelectFiles::Substitute.build
      end
      attr_writer :select_files

      def isolate
        @isolate ||= Isolate::Substitute.build
      end
      attr_writer :isolate

      def random_generator
        @random_generator ||= Pseudorandom::Generator.build
      end
      attr_writer :random_generator

      def path_sequence
        @path_sequence ||= 0
      end
      attr_writer :path_sequence

      def abort_on_failure
        @abort_on_failure.nil? ?
          @abort_on_failure = Defaults.abort_on_failure :
          @abort_on_failure
      end
      attr_writer :abort_on_failure

      def self.build(exclude: nil, session: nil)
        session ||= Session.build do |telemetry|
          Output.register(telemetry)
        end

        instance = new

        instance.session = session

        SelectFiles.configure(instance, exclude:)
        Pseudorandom::Generator.configure(instance)
        Isolate.configure(instance, session:)

        instance
      end

      def self.call(path, session: nil, exclude: nil)
        instance = build(session:, exclude:)

        original_session = Session.instance

        Session.instance = instance.session

        begin
          instance.(path)
        ensure
          Session.instance = original_session
        end
      end

      def self.configure(receiver, exclude: nil, session: nil, attr_name: nil)
        attr_name ||= :run

        instance = build(exclude:, session:)
        receiver.public_send(:"#{attr_name}=", instance)
      end

      def call(path)
        run do
          path(path)
        end
      end

      def run(&block)
        if ran?
          raise Error, "Already ran"
        end

        session.record_event(Started.build(random_generator.seed))

        isolate.start

        if not block.nil?
          block.(self)

          if not ran?
            raise Error, "No paths were supplied"
          end
        end

        isolate.stop

        if session.passed?
          result = true
        elsif session.failed?
          result = false
        end

        session.record_event(Finished.build(random_generator.seed, result))
        result
      end
      alias :! :run

      def path(path)
        if abort_on_failure && session.failed?
          return
        end

        self.path_sequence += 1

        select_files.(path) do |file|
          isolate.run(file)
        end
      end
      alias :<< :path

      def ran?
        path_sequence > 0
      end

      module Defaults
        def self.abort_on_failure
          ENV.fetch('TEST_ABORT_ON_FAILURE', 'off') == 'on'
        end
      end
    end
  end
end
