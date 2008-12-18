module Ratpack
  # A multipart form data parser, adapted from rack.
  module Multipart
    EOL = "\r\n"

    def parse_multipart(env, post_data)
      unless env['CONTENT_TYPE'] =~
          %r|\Amultipart/form-data.*boundary=\"?([^\";,]+)\"?|n
        nil
      else
        boundary = "--#{$1}"

        params = {}
        buf = ""
        content_length = post_data.length
        input = post_data

        boundary_size = boundary.size + EOL.size
        bufsize = 16384

        content_length -= boundary_size

        status = input.read(boundary_size)
        raise EOFError, "bad content body"  unless status == boundary + EOL

        rx = /(?:#{EOL})?#{Regexp.quote boundary}(#{EOL}|--)/

        loop {
          head = nil
          body = ''
          filename = content_type = name = nil

          until head && buf =~ rx
            if !head && i = buf.index("\r\n\r\n")
              head = buf.slice!(0, i+2) # First \r\n
              buf.slice!(0, 2)          # Second \r\n

              filename = head[/Content-Disposition:.* filename="?([^\";]*)"?/ni, 1]
              content_type = head[/Content-Type: (.*)\r\n/ni, 1]
              name = head[/Content-Disposition:.* name="?([^\";]*)"?/ni, 1]

              if filename
                body = Tempfile.new("RackMultipart")
                body.binmode  if body.respond_to?(:binmode)
              end

              next
            end

            # Save the read body part.
            if head && (boundary_size+4 < buf.size)
              body << buf.slice!(0, buf.size - (boundary_size+4))
            end

            c = input.read(bufsize < content_length ? bufsize : content_length)
            raise EOFError, "bad content body"  if c.nil? || c.empty?
            buf << c
            content_length -= c.size
          end

          # Save the rest.
          if i = buf.index(rx)
            body << buf.slice!(0, i)
            buf.slice!(0, boundary_size+2)

            content_length = -1  if $1 == "--"
          end

          if filename
            body.rewind
            data = {:filename => filename, :type => content_type,
                    :name => name, :tempfile => body, :head => head}
          else
            data = body
          end

          if name
            if name =~ /\[\]\z/
              params[name] ||= []
              params[name] << data
            else
              params[name] = data
            end
          end

          break  if buf.empty? || content_length == -1
        }

        params
      end
    end
  end
end