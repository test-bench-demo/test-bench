module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              module Commented
                def self.example(text: nil, disposition: nil)
                  text ||= self.text

                  if disposition == :none
                    disposition = nil
                  else
                    disposition ||= self.disposition
                  end

                  commented = Session::Events::Commented.new

                  commented.text = text
                  commented.disposition = disposition

                  commented.metadata = Metadata.example

                  commented
                end

                def self.text
                  Text::Comment.example
                end

                def self.disposition
                  CommentDisposition.example
                end

                def self.other_example
                  Other.example
                end

                module Other
                  def self.example
                    Commented.example(text:, disposition:)
                  end

                  def self.text
                    Text::Comment.other_example
                  end

                  def self.disposition
                    CommentDisposition.other_example
                  end
                end

                module NoDisposition
                  def self.example
                    Commented.example(disposition: :none)
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
