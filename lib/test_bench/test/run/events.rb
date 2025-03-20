module TestBench
  module Test
    class Run
      module Events
        FileStarted = Telemetry::Event.define(:file)
        FileFinished = Telemetry::Event.define(:file, :result)
        FileTerminated = Telemetry::Event.define(:file, :error_message, :error_text)
        FileNotFound = Telemetry::Event.define(:file)

        Started = Telemetry::Event.define(:random_seed)
        Finished = Telemetry::Event.define(:random_seed, :result)
      end
    end
  end
end
