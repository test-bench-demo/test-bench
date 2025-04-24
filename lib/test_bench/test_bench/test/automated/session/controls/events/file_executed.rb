module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Events
              module FileExecuted
                def self.example(result: nil, file: nil)
                  result ||= self.result
                  file ||= self.file

                  file_executed = Session::Events::FileExecuted.new

                  file_executed.file = file
                  file_executed.result = result

                  file_executed.metadata = Metadata.example

                  file_executed
                end

                def self.file
                  Path::File.example
                end

                def self.result
                  Result.example
                end

                def self.other_example
                  Other.example
                end

                module Other
                  def self.example
                    FileExecuted.example(result:, file:)
                  end

                  def self.result
                    Result.other_example
                  end

                  def self.file
                    Path::File.other_example
                  end
                end

                module Passed
                  def self.example
                    FileExecuted.example(result:)
                  end

                  def self.result
                    Session::Result.passed
                  end
                end

                module Failed
                  def self.example
                    FileExecuted.example(result:)
                  end

                  def self.result
                    Session::Result.failed
                  end
                end

                module Inert
                  def self.example
                    FileExecuted.example(result:)
                  end

                  def self.result
                    Session::Result.none
                  end
                end

                module Aborted
                  def self.example
                    FileExecuted.example(result:)
                  end

                  def self.result
                    Session::Result.aborted
                  end
                end

                module Incomplete
                  def self.example
                    FileExecuted.example(result:)
                  end

                  def self.result
                    Session::Result.incomplete
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
