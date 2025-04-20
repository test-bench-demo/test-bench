module TestBench
  module Test
    module Automated
      class Run
        class SelectFiles
          PathNotFoundError = Class.new(RuntimeError)

          def exclude_patterns
            @exclude_patterns ||= []
          end
          attr_writer :exclude_patterns

          attr_accessor :apex_directory

          def self.build(exclude_patterns: nil)
            exclude_patterns ||= Defaults.exclude_file_patterns

            instance = new
            instance.exclude_patterns = exclude_patterns
            instance
          end

          def self.configure(receiver, exclude_patterns: nil, attr_name: nil)
            attr_name ||= :select_files

            instance = build(exclude_patterns:)
            receiver.public_send(:"#{attr_name}=", instance)
          end

          def call(path, &block)
            full_path = ::File.expand_path(path, apex_directory)
            if not ::File.exist?(full_path)
              raise PathNotFoundError, "No such file or directory - #{full_path}"
            end

            extension = ::File.extname(path)

            if extension.empty?
              directory_path = path
              glob_pattern = ::File.join(directory_path, '**', '*.rb')
            else
              file_path = path
              glob_pattern = file_path
            end

            Dir.glob(glob_pattern, base: apex_directory) do |file|
              excluded = exclude_patterns.any? do |exclude_pattern|
                ::File.fnmatch?(exclude_pattern, file, ::File::FNM_EXTGLOB)
              end

              if excluded
                next
              end

              block.(file)
            end
          end

          module Defaults
            def self.exclude_file_patterns
              env_exclude_file_patterns = ENV.fetch('TEST_RUN_EXCLUDE_FILE_PATTERNS', '*_init.rb')

              env_exclude_file_patterns.split(':')
            end
          end
        end
      end
    end
  end
end
