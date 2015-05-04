# color-sdk-ruby

#### Usage

```ruby
require "color"

# init with the SQS endpoint
sdk = Color::SDK.new( "https://sqs.us-east-1.amazonaws.com/12345678/test" )

# add arbitrary objects to the internal buffer
sdk.write({ event: "install", user: 15, device: "iPhone" }) 
sdk.write({ event: "click", user: 12, device: "iPad" })
sdk.flush() # send the internal buffer to the queue
```