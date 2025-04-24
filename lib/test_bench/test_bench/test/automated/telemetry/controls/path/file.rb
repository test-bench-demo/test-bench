module TestBench
  module TestBench
    module Test
      module Automated
        class Telemetry
          module Controls
            module Path
              module File
                def self.example(basename: nil, extension: nil)
                  basename ||= self.basename
                  extension ||= self.extension

                  filename = "#{basename}#{extension}"

                  tempfile = Tempfile.create(filename)
                  tempfile.close

                  ::File.unlink(tempfile)

                  tempfile.path
                end

                def self.basename
                  "some-basename"
                end

                def self.extension
                  ".some-extension"
                end

                module Read
                  def self.call(file_path)
                    ::File.read(file_path)
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
