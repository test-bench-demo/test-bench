module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              module TestFinished
                def self.example(result: nil, title: nil)
                  result ||= self.result

                  if title == :none
                    title = nil
                  else
                    title ||= self.title
                  end

                  test_finished = Session::Events::TestFinished.new

                  test_finished.title = title
                  test_finished.result = result

                  test_finished.metadata = Metadata.example

                  test_finished
                end

                def self.title
                  Title::Test.example
                end

                def self.result
                  Result.example
                end

                def self.other_example
                  Other.example
                end

                module Other
                  def self.example
                    TestFinished.example(result:, title:)
                  end

                  def self.result
                    Result.other_example
                  end

                  def self.title
                    Title::Test.other_example
                  end
                end

                module NoTitle
                  def self.example
                    TestFinished.example(title: :none)
                  end
                end

                module Passed
                  def self.example
                    TestFinished.example(result:)
                  end

                  def self.result
                    Session::Result.passed
                  end
                end

                module Failed
                  def self.example
                    TestFinished.example(result:)
                  end

                  def self.result
                    Session::Result.failed
                  end
                end

                module Aborted
                  def self.example
                    TestFinished.example(result:)
                  end

                  def self.result
                    Session::Result.aborted
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
