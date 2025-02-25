module TestBench
  module Test
    class Run
      Error = Class.new(RuntimeError)

      include Events

      def telemetry
        @telemetry ||= Telemetry::Substitute.build
      end
      attr_writer :telemetry

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

      def self.build(exclude: nil, session: nil, isolate: nil)
        instance = new

        SelectFiles.configure(instance, exclude:)

        Pseudorandom::Generator.configure(instance)

        Isolate.configure(instance, session:, isolate:)

        if session.nil?
          session = Session.build do |telemetry|
            Output::File.register(telemetry)
            Output::Summary::Error.register(telemetry)
            Output::Summary.register(telemetry)
          end
        end

        instance.telemetry = session.telemetry

        Session.configure(instance, session:)

        instance
      end

      def self.call(path, session_store: nil, exclude: nil)
        session_store ||= Session::Store.instance

        instance = build(exclude:)

        session_store.reset(instance.session)

        instance.(path)
      end

      def self.configure(receiver, exclude: nil, session: nil, isolate: nil, attr_name: nil)
        attr_name ||= :run

        instance = build(exclude:, session:, isolate:)
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

        telemetry.record(Started.build(random_generator.seed))

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

        telemetry.record(Finished.build(random_generator.seed, result))
        result
      end
      alias :! :run

      def path(path)
        self.path_sequence += 1

        select_files.(path) do |file|
          isolate.run(file)
        end
      end
      alias :<< :path

      def ran?
        path_sequence > 0
      end
    end
  end
end
