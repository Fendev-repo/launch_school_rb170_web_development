require 'socket'

server = TCPServer.new('localhost', 3003)

def parse_http_to_components(str)
  http_method = str.split[0]
  path = str.split[1].split('?').first

  parameters = {}
  str.split[1].split('?').last.split('&').each do |params|
    parameters[params.split('=').first] = params.split('=').last
  end
  [http_method, path, parameters]
end

loop do
  client = server.accept

  request_line = client.gets
  http_method, path, parameters = parse_http_to_components(request_line)
  puts request_line

  client.puts "HTTP/1.1 200 OK\r\n\r\n"
  client.puts "Content-Type: text/plain\r\n\r\n"

  parameters['rolls'].to_i.times do
    client.puts rand(parameters['sides'].to_i) + 1
  end
  client.puts 'Thank you - please submit another HTTP request'
  client.close
end
# To run program - simply execute this script using $ ruby server.rb
# Then open a browser to localhost:3003
# Then in the address bar of the browser type HTTP requests
