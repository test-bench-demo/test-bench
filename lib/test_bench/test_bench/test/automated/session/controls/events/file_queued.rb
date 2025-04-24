module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              module FileQueued
                def self.example(file: nil)
                  file ||= self.file

                  file_queued = Session::Events::FileQueued.new

                  file_queued.file = file

                  file_queued.metadata = Metadata.example

                  file_queued
                end

                def self.file
                  Path::File.example
                end

                def self.other_example
                  Other.example
                end

                module Other
                  def self.example
                    FileQueued.example(file:)
                  end

                  def self.file
                    Path::File.other_example
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
