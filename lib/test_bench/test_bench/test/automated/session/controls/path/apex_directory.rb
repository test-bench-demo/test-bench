module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Path
              module ApexDirectory
                def self.example(name=nil)
                  name ||= Name.example

                  ::File.expand_path(name, tmpdir)
                end

                def self.tmpdir
                  ::Dir.tmpdir
                end

                module Name
                  def self.example
                    'test-automated-session-controls'
                  end

                  def self.random
                    "#{example}-#{Random.string}"
                  end
                end

                module Create
                  def self.call(name=nil)
                    name ||= Name.random

                    apex_directory = ApexDirectory.example(name)

                    ::Dir.mkdir(apex_directory)

                    if ENV.fetch('DEBUG_PATH_CONTROLS', 'off') == 'on'
                      warn "created directory '#{apex_directory}'"
                    end

                    apex_directory
                  end
                end

                module Remove
                  def self.call(apex_directory)
                    remove(apex_directory)
                  end

                  def self.remove(directory)
                    ::Dir.each_child(directory) do |entry|
                      absolute_path = ::File.expand_path(entry, directory)

                      if ::File.directory?(absolute_path)
                        subdirectory = absolute_path
                        remove(subdirectory)
                      else
                        ::File.unlink(absolute_path)

                        if ENV.fetch('DEBUG_PATH_CONTROLS', 'off') == 'on'
                          warn "removed '#{absolute_path}'"
                        end
                      end
                    end

                    ::Dir.rmdir(directory)

                    if ENV.fetch('DEBUG_PATH_CONTROLS', 'off') == 'on'
                      warn "removed directory '#{directory}'"
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
end
