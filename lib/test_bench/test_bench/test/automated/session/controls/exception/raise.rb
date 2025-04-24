module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Exception
              module Raise
                def self.call(exception_class, exception_message)
                  apex_directory = Path::ApexDirectory::Create.()

                  file_1 = Controls::Path::File::Create.(<<~RUBY, subdirectory: :none, apex_directory:)
                  #{Controls::Exception}::SomeNamespace.module_exec { def self.some_method = raise #{exception_class}, #{exception_message.inspect}, caller_locations(0, 4) }
                  RUBY

                  file_2 = Controls::Path::File::Create.(<<~RUBY, basename: 'some-file', apex_directory:)
                  module #{Controls::Exception}::SomeNamespace
                    def self.some_other_method = some_method
                  end
                  RUBY

                  file_3 = Controls::Path::File::Create.(<<~RUBY, basename: 'some-other-file', apex_directory:)
                  module #{Controls::Exception}
                    module SomeNamespace
                      def self.yet_another_method = some_other_method
                    end
                  end
                  RUBY

                  file_4 = Controls::Path::File::Create.(<<~RUBY, basename: 'some-other-file', subdirectory: :none, apex_directory:)
                  #{[file_3, file_2, file_1].inspect}.each { |file| load file }

                  module #{Controls::Exception}::SomeNamespace
                    def self.origin = yet_another_method; origin
                  end
                  RUBY

                  ::Dir.chdir(apex_directory) do
                    load file_4
                  end

                ensure
                  Path::ApexDirectory::Remove.(apex_directory)
                end
              end
            end
          end
        end
      end
    end
  end
end
