module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              module ContextStarted
                def self.example(title: nil)
                  if title == :none
                    title = nil
                  else
                    title ||= self.title
                  end

                  context_started = Session::Events::ContextStarted.new

                  context_started.title = title

                  context_started.metadata = Metadata.example

                  context_started
                end

                def self.title
                  Title::Context.example
                end

                def self.other_example
                  Other.example
                end

                module Other
                  def self.example
                    ContextStarted.example(title:)
                  end

                  def self.title
                    Title::Context.other_example
                  end
                end

                module NoTitle
                  def self.example
                    ContextStarted.example(title: :none)
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
