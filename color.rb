require "json"
require "openssl"
require "net/http"

module Color
    class SDK
        def initialize ( queue )
            @queue = queue
            @buffer = "";
        end

        def write ( entry )
            @buffer += entry.to_json + "\n"
            if @buffer.size >= 60000
                flush() # auto-flush
            end

            return self
        end

        def flush
            buffer = @buffer
            @buffer = ""

            uri = URI.parse( @queue )
            http = Net::HTTP.new( uri.host, uri.port )
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            req = Net::HTTP::Post.new( uri.path )
            req.body = "Action=SendMessage&MessageBody=" + buffer
            Thread.new do 
                http.request( req )
            end

            return self
        end
    end
end