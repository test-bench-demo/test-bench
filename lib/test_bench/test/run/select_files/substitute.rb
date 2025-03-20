module TestBench
  module Test
    class Run
      class SelectFiles
        module Substitute
          def self.build
            SelectFiles.new
          end

          class SelectFiles
            def files
              @files ||= []
            end
            attr_writer :files
            alias :set_files :files=

            def paths
              @paths ||= []
            end

            def call(path, &block)
              self.paths << path

              files.each(&block)
            end

            def path?(path)
              paths.include?(path)
            end
          end
        end
      end
    end
  end
end
