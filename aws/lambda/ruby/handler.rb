require 'json'

def handler(event:, context:)
    qs = event.fetch("queryStringParameters", {})

    name = qs.fetch("name", "unknown user")
   
    STDERR.puts "Handling ALB request for #{name}"

    {
        "statusCode": 200,
        "statusDescription": "200 OK",
        "isBase64Encoded": false,
        "headers": {
            "Content-Type": "text/html"
        },
        "body": "<html><body><h1>Howdy #{name} from Lambda!</h1></html></body>"
    }
end