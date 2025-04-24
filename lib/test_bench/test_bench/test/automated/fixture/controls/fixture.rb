module TestBench
  module TestBench
    module Test
      module Automated
        module Fixture
          module Controls
            module Fixture
              def self.example
                Example.new
              end

              class Example
                include Test::Automated::Fixture

                attr_accessor :actuated

                attr_reader :some_argument
                attr_reader :some_keyword_argument
                attr_reader :some_block_argument

                def initialize(some_argument=nil, some_keyword_argument: nil, &some_block_argument)
                  @some_argument = some_argument
                  @some_keyword_argument = some_keyword_argument
                  @some_block_argument = some_block_argument
                end

                def actuated?
                  actuated ? true : false
                end

                def call
                  self.actuated = true
                end
              end

              class BuildMethod
                include Test::Automated::Fixture

                attr_accessor :some_argument
                attr_accessor :some_optional_argument
                attr_accessor :some_keyword_argument
                attr_accessor :some_optional_keyword_argument
                attr_accessor :some_block_argument

                def self.build(some_argument, some_optional_argument=nil, some_keyword_argument:, some_optional_keyword_argument: nil, &some_block_argument)
                  instance = new

                  instance.some_argument = some_argument
                  instance.some_optional_argument = some_optional_argument
                  instance.some_keyword_argument = some_keyword_argument
                  instance.some_optional_keyword_argument = some_optional_keyword_argument
                  instance.some_block_argument = some_block_argument

                  instance
                end
              end

              class NoBuildMethod
                include Test::Automated::Fixture

                attr_reader :some_argument

                def initialize(some_argument)
                  @some_argument = some_argument
                end
              end
            end
          end
        end
      end
    end
  end
end
