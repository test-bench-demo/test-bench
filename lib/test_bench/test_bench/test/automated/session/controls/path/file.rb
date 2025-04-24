module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Path
              module File
                def self.example(basename: nil, extension: nil, directory: nil, subdirectory: nil, apex_directory: nil)
                  basename ||= self.basename
                  extension ||= self.extension

                  filename = "#{basename}#{extension}"

                  Path.example(name: filename, directory:, subdirectory:, apex_directory:)
                end

                def self.basename
                  'some-file'
                end

                def self.extension
                  '.rb'
                end

                def self.other_example
                  Other.example
                end

                module Other
                  def self.example(apex_directory: nil)
                    File.example(basename:, apex_directory:)
                  end

                  def self.basename
                    'some-other-file'
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
