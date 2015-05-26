require "./color"

sdk = Color::SDK.new( "us-east-1/037335999562/test", "test" )
sdk.write({hello:'world'})
sdk.flush()

sleep( 5 )