module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              module FileNotFound
                def self.example(file: nil)
                  file ||= self.file

                  file_not_found = Session::Events::FileNotFound.new

                  file_not_found.file = file

                  file_not_found.metadata = Metadata.example

                  file_not_found
                end

                def self.file
                  Path::File.example
                end

                def self.other_example
                  Other.example
                end

                module Other
                  def self.example
                    FileNotFound.example(file:)
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
