module TestBench
  def self.activate(receiver=nil)
    receiver ||= TOPLEVEL_BINDING.receiver

    receiver.extend(Fixture)
    receiver.extend(DeactivatedVariants)
    receiver.extend(TestSession)
  end

  def self.context(title=nil, session: nil, &block)
    evaluate(session:) do
      context(title) do
        instance_exec(&block)
      end
    end
  end

  def self.evaluate(session: nil, &block)
    original_session = Test::Session.instance

    Test::Session.instance = session

    fixture = TestBench::Fixture::Evaluate.build(session:, &block)
    fixture.extend(DeactivatedVariants)
    fixture.()

    fixture.test_session.passed?

  ensure
    self.session = original_session
  end

  def self.session
    Test::Session.instance
  end

  def self.session=(session)
    Test::Session.instance = session
  end

  def self.telemetry
    session.telemetry
  end

  def self.register_telemetry_sink(telemetry_sink)
    session.register_telemetry_sink(telemetry_sink)
  end

  module DeactivatedVariants
    def _context(title=nil, &)
      context(title)
    end

    def _test(title=nil, &)
      test(title)
    end
  end

  module TestSession
    def test_session
      TestBench.session
    end

    def test_session=(session)
      TestBench.session = session
    end
  end
end
