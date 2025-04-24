module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Path
              def self.example(name: nil, directory: nil, subdirectory: nil, apex_directory: nil)
                if apex_directory.nil?
                  Relative.example(name:, directory:, subdirectory:)
                else
                  Absolute.example(name:, directory:, subdirectory:, apex_directory:)
                end
              end

              def self.name
                'some-entry'
              end

              def self.directory
                'some-dir'
              end

              def self.subdirectory
                'some-subdir'
              end

              module Absolute
                def self.example(name: nil, directory: nil, subdirectory: nil, apex_directory: nil)
                  apex_directory ||= self.apex_directory

                  relative_path = Relative.example(name:, directory:, subdirectory:)

                  ::File.join(apex_directory, relative_path)
                end

                def self.apex_directory
                  '/'
                end
              end

              module Relative
                def self.example(name: nil, directory: nil, subdirectory: nil)
                  name ||= Path.name

                  if directory == :none
                    directory = nil
                  else
                    directory ||= Path.directory
                  end

                  if subdirectory == :none
                    subdirectory = nil
                  elsif not directory.nil?
                    subdirectory ||= Path.subdirectory
                  end

                  segments = [directory, subdirectory, name].compact

                  ::File.join(*segments)
                end
              end
            end
          end
        end
      end
    end
  end
end
