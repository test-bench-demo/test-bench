module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              module Failed
                def self.example(message: nil)
                  message ||= self.message

                  failed = Session::Events::Failed.new

                  failed.message = message

                  failed.metadata = Metadata.example

                  failed
                end

                def self.message
                  Message::Failure.example
                end

                def self.other_example
                  Other.example
                end

                module Other
                  def self.example
                    Failed.example(message:)
                  end

                  def self.message
                    Message::Failure.other_example
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
