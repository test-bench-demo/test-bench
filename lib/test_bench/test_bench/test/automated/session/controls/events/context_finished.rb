module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              module ContextFinished
                def self.example(result: nil, title: nil)
                  result ||= self.result

                  if title == :none
                    title = nil
                  else
                    title ||= self.title
                  end

                  context_finished = Session::Events::ContextFinished.new

                  context_finished.title = title
                  context_finished.result = result

                  context_finished.metadata = Metadata.example

                  context_finished
                end

                def self.title
                  Title::Context.example
                end

                def self.result
                  Result.example
                end

                def self.other_example
                  Other.example
                end

                module Other
                  def self.example
                    ContextFinished.example(result:, title:)
                  end

                  def self.result
                    Result.other_example
                  end

                  def self.title
                    Title::Context.other_example
                  end
                end

                module NoTitle
                  def self.example
                    ContextFinished.example(title: :none)
                  end
                end

                module Passed
                  def self.example
                    ContextFinished.example(result:)
                  end

                  def self.result
                    Session::Result.passed
                  end
                end

                module Failed
                  def self.example
                    ContextFinished.example(result:)
                  end

                  def self.result
                    Session::Result.failed
                  end
                end

                module Inert
                  def self.example
                    ContextFinished.example(result:)
                  end

                  def self.result
                    Session::Result.none
                  end
                end

                module Aborted
                  def self.example
                    ContextFinished.example(result:)
                  end

                  def self.result
                    Session::Result.aborted
                  end
                end

                module Incomplete
                  def self.example
                    ContextFinished.example(result:)
                  end

                  def self.result
                    Session::Result.incomplete
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
