module TestBench
  module TestBench
    module Test
      module Automated
        class Session
          module Controls
            module Path
              module File
                module Create
                  def self.call(content=nil, basename: nil, extension: nil, directory: nil, subdirectory: nil, apex_directory: nil, relative: nil)
                    if relative.nil?
                      relative = !apex_directory.nil?
                    end

                    apex_directory ||= ::Dir.tmpdir

                    absolute_path = File.example(basename:, extension:, directory:, subdirectory:, apex_directory:)

                    relative_path = absolute_path.delete_prefix(::File.join(apex_directory, ''))

                    if relative
                      file_path = relative_path
                    else
                      file_path = absolute_path
                    end

                    content ||= "# #{file_path}\n"

                    segments = []

                    until ['.', '/'].include?(relative_path)
                      segments.unshift(::File.basename(relative_path))

                      relative_path = ::File.dirname(relative_path)
                    end

                    (1...segments.length).each do |index|
                      directory_segments = segments[...index]

                      directory = ::File.join(apex_directory, *directory_segments)

                      if not ::File.directory?(directory)
                        ::Dir.mkdir(directory)
                      end
                    end

                    ::File.write(absolute_path, content)

                    if ENV.fetch('DEBUG_PATH_CONTROLS', 'off') == 'on'
                      warn "created '#{absolute_path}'"
                    end

                    file_path
                  end

                  module Exception
                    def self.call
                      Create.(content, basename:)
                    end

                    def self.basename
                      'some_aborting_file.rb'
                    end

                    def self.content
                      <<~RUBY
                      raise #{Controls::Exception::Example}
                      RUBY
                    end
                  end

                  module Comment
                    def self.call(text: nil)
                      text ||= self.text

                      basename = "write_comment__#{text.gsub(' ', '_')}"

                      content = Content.example(text:)

                      Create.(content, basename:)
                    end

                    def self.content
                      Content.example
                    end

                    def self.basename
                      'some_commenting_file'
                    end

                    def self.text
                      Text::Comment.example
                    end

                    module Content
                      def self.example(text: nil)
                        text ||= Comment.text

                        <<~RUBY
                        comment_text = #{text.inspect}

                        commented = #{Controls::Events::Commented}.example(text: comment_text)

                        Session.instance.record_event(commented)
                        RUBY
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
end
