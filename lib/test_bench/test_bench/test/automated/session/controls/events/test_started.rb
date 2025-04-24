module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              module TestStarted
                def self.example(title: nil)
                  if title == :none
                    title = nil
                  else
                    title ||= self.title
                  end

                  test_started = Session::Events::TestStarted.new

                  test_started.title = title

                  test_started.metadata = Metadata.example

                  test_started
                end

                def self.title
                  Title::Test.example
                end

                def self.other_example
                  Other.example
                end

                module Other
                  def self.example
                    TestStarted.example(title:)
                  end

                  def self.title
                    Title::Test.other_example
                  end
                end

                module NoTitle
                  def self.example
                    TestStarted.example(title: :none)
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
