require "json"
require "openssl"
require "net/http"

module Color
    class SDK
        def initialize ( key, secret )
            parts = key.split( "/" )
            region = parts.shift()
            url = parts.join( "/" )

            @queue = "https://sqs." + region + ".amazonaws.com/" + url
            @key = key
            @secret = secret
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
            req.body = "Action=SendMessage" +
                "&MessageAttribute.1.Name=key" +
                "&MessageAttribute.1.Value.DataType=String" + 
                "&MessageAttribute.1.Value.StringValue=" + @key + 
                "&MessageAttribute.2.Name=secret" +
                "&MessageAttribute.2.Value.DataType=String" +
                "&MessageAttribute.2.Value.StringValue=" + @secret +
                "&MessageBody=" + buffer.encode( "utf-8" )
            
            Thread.new do 
                res = http.request( req )
            end

            return self
        end
    end
end