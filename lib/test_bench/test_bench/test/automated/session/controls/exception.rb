module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Exception
              def self.example(exception_message: nil, exception_class: nil)
                exception_message ||= self.exception_message
                exception_class ||= self.exception_class

                Raise.(exception_class, exception_message)
              rescue exception_class => exception
                return exception
              else
                abort "Unreachable"
              end

              def self.exception_message
                "Some exception"
              end

              def self.exception_class
                SomeException
              end

              SomeException = Class.new(::Exception)
              SomeOtherException = Class.new(::Exception)

              Example = self.example

              module Other
                def self.example
                  Exception.example(exception_message:, exception_class:)
                end

                def self.exception_message
                  "Some other exception"
                end

                def self.exception_class
                  SomeOtherException
                end

                Example = self.example
              end

              module Cause
                def self.example(exception_message: nil, exception_class: nil)
                  exception_message ||= self.exception_message
                  exception_class ||= self.exception_class

                  Raise.(exception_class, exception_message)
                rescue SomeOtherException
                  exception = Exception.example(exception_message:, exception_class:)
                  return exception
                else
                  abort "Unreachable"
                end

                def self.exception_message
                  "Some exception cause"
                end

                def self.exception_class
                  SomeOtherException
                end

                Example = self.example
              end
            end
          end
        end
      end
    end
  end
end
