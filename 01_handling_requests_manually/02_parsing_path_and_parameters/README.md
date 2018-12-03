# Parsing Path and Parameters

### Assignment
Based on the code in ../01_a_simple_echo_server/server.rb
Write code that takes the following string
"GET /?rolls=2&sides=6 HTTP/1.1"
And splits it apart into the following pieces;

http_method = "GET"
path = "/"
params = { "rolls" => "2", "sides" => "6" }

Then add some code to enable the new variables to be 
outputted to the terminal for debugging purposes.

The add some code to enable the n number of rolls.
The add some code to enable the n number of dice sides.


  - Problem
    - What varible is the example string stored? (based on existing code)
      - The exampe string is stores in request_line local variable

    - How will I split the string (from request_line) into the required
      local variables?
      "GET" => could also be "POST", "DELETE", "PATCH" 
      "/"
      "?"
      "rolls=2"
      "&"
      "sides=6" 
      "HTTP/1.1"
      Based on the local variable in the existing program, the TCPServer
      class provides the input like this;

      example = "GET /hello?rolls=2&sides=6 HTTP/1.1\r\n"
    
      - I will first use the String#split => ["GET", "/hello?rolls=2&sides=6", "HTTP/1.1"]
        I will save the return value (Array) to a local variable 'complete_http_request'      
      
      - Next, I will isolate the http_method 
        - complete_http_request[0] => "/hello?rolls=2&sides=6"

      - Finally, I will seperate the path from the params
        -  "/hello?rolls=2&sides=6".split('?') => ["/hello", "rolls=2&sides=6"]

      - I will assign the path to path local variable using
        - ["/hello", "rolls=2&sides=6"].first = "/hello"

      - Finally, ["/hello", "rolls=2&sides=6"].last.split('&') => ["rolls=2", "sides=6"]

      - "rolls=2".split('=') => ["rolls", "2"]
        ["rolls", "2"].first => key
        ["rolls", "2"].last => value

      
  - Examples
  - Data-structures
  - Algorithm
  - Code