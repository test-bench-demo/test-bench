module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              module Aborted
                def self.example(message: nil)
                  message ||= self.message

                  aborted = Session::Events::Aborted.new

                  aborted.message = message

                  aborted.metadata = Metadata.example

                  aborted
                end

                def self.message
                  Exception::Message.example
                end

                def self.other_example
                  Other.example
                end

                module Other
                  def self.example
                    Aborted.example(message:)
                  end

                  def self.message
                    Message::Error.other_example
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
