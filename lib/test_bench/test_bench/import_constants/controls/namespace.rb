module TestBench
  module TestBench
    module ImportConstants
      module Controls
        module Namespace
          def self.example(name: nil, &block)
            Example
          end

          module Example
            module SomeConstant
            end

            module SomeOtherConstant
            end
          end

          module Anonymous
            def self.example(name: nil, &block)
              name ||= self.name

              namespace = Module.new
              namespace.set_temporary_name(name)

              if not block.nil?
                namespace.module_exec(&block)
              end

              namespace
            end

            def self.name
              'Some Anonymous Module'
            end
          end

          module Target
            def self.example(name: nil, &block)
              name ||= self.name

              Anonymous.example(name:)
            end

            def self.name
              'Some Target Module'
            end
          end

          module InheritNamespace
            def self.example(namespace=nil)
              namespace ||= Namespace.example

              Anonymous.example(name:) do
                include namespace
              end
            end

            def self.name
              'Include Namespace'
            end
          end

          module AliasNamespace
            def self.example(namespace=nil, name: nil)
              namespace ||= Namespace.example

              constant_names = namespace.constants(false)

              Anonymous.example(name:) do
                constant_names.each do |constant_name|
                  constant = namespace.const_get(constant_name)

                  const_set(constant_name, constant)
                end
              end
            end

            def self.name
              'Alias Namespace'
            end
          end
        end
      end
    end
  end
end
