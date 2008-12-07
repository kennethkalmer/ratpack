module Ratpack
  # Simple wrapper for the responses from sending methods
  class Response

    def initialize( message, recipients = [], error = nil )
      @message = message
      @recipients = recipients.to_a.flatten.compact
      @error = error
    end

    def to_xml
      xml = "<response>"
      xml << "<message>#{@message}</message>"
      @recipients.each { |r| xml << "<recipient>#{r}</recipient>" }
      xml << "<error>#{@error}</error>" if @error
      xml << "</response>"
    end
    alias to_s to_xml

  end
end
