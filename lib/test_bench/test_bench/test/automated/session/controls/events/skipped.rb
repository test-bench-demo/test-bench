module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              module Skipped
                def self.example(message: nil)
                  if message == :none
                    message = nil
                  else
                    message ||= self.message
                  end

                  skipped = Session::Events::Skipped.new

                  skipped.message = message

                  skipped.metadata = Metadata.example

                  skipped
                end

                def self.message
                  Message::Skip.example
                end

                def self.other_example
                  Other.example
                end

                module Other
                  def self.example
                    Skipped.example(message:)
                  end

                  def self.message
                    Message::Skip.other_example
                  end
                end

                module NoMessage
                  def self.example
                    Skipped.example(message: :none)
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
