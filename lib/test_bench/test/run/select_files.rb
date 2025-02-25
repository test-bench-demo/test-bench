module TestBench
  module Test
    class Run
      class SelectFiles
        attr_reader :exclude_patterns

        def initialize(exclude_patterns)
          @exclude_patterns = exclude_patterns
        end

        def self.build(exclude: nil)
          exclude_patterns = exclude
          exclude_patterns ||= Defaults.exclude_patterns

          if exclude_patterns.instance_of?(String)
            exclude_patterns = exclude_patterns.split(':')
          end

          new(exclude_patterns)
        end

        def self.call(path, exclude: nil, &block)
          instance = build(exclude:)
          instance.(path, &block)
        end

        def self.configure(receiver, exclude: nil, attr_name: nil)
          attr_name ||= :select_files

          instance = build(exclude:)
          receiver.public_send(:"#{attr_name}=", instance)
        end

        def call(path, &block)
          if ::File.extname(path).empty?
            pattern = ::File.join(path, '**/*.rb')
          else
            pattern = path
          end

          files = Dir.glob(pattern)

          if files.empty?
            files << path
          end

          files.each do |file|
            excluded = exclude_patterns.any? do |exclude_pattern|
              exclude_pattern = ::File.join('*', exclude_pattern)

              ::File.fnmatch?(exclude_pattern, file, ::File::FNM_EXTGLOB)
            end

            if excluded
              next
            end

            block.(file)
          end
        end

        module Defaults
          def self.exclude_patterns
            ENV.fetch('TEST_EXCLUDE_FILE_PATTERN') do
              ## Remove when no longer needed - Nathan, Sat Sep 7 2024
              ENV.fetch('TEST_BENCH_EXCLUDE_FILE_PATTERN') do
                '*_init.rb'
              end
            end
          end
        end
      end
    end
  end
end
