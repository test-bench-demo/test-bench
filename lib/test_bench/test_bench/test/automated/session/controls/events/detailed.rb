module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              module Detailed
                def self.example(text: nil, disposition: nil)
                  text ||= self.text

                  if disposition == :none
                    disposition = nil
                  else
                    disposition ||= self.disposition
                  end

                  detailed = Session::Events::Detailed.new

                  detailed.text = text
                  detailed.disposition = disposition

                  detailed.metadata = Metadata.example

                  detailed
                end

                def self.text
                  Text::Detail.example
                end

                def self.disposition
                  CommentDisposition.example
                end

                def self.other_example
                  Other.example
                end

                module NoDisposition
                  def self.example
                    Detailed.example(disposition: :none)
                  end
                end

                module Other
                  def self.example
                    Detailed.example(text:, disposition:)
                  end

                  def self.text
                    Text::Detail.other_example
                  end

                  def self.disposition
                    CommentDisposition.other_example
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
