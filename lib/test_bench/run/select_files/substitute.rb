module TestBench
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

          attr_accessor :raise_path_not_found_error

          def raise_path_not_found_error!
            self.raise_path_not_found_error = true
          end

          def call(path, &block)
            if raise_path_not_found_error
              raise PathNotFoundError
            end

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
