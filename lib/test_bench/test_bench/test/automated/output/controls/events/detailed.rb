module TestBench
  module TestBench
    module Test
      module Automated
        class Output
          module Controls
            module Events
              module Detailed
                def self.example(text: nil, style: nil)
                  style ||= self.style

                  disposition = Output::CommentStyle.get_disposition(style)

                  Session::Events::Detailed.example(text:, disposition:)
                end

                def self.style
                  CommentStyle.example
                end
              end
            end
          end
        end
      end
    end
  end
end
