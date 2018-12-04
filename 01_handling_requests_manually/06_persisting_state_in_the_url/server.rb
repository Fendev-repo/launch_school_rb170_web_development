require 'socket'

server = TCPServer.new('localhost', 3003)

def parse_http_to_components(str)
  return unless str.include?('?')

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
  next unless request_line

  http_method, path, parameters = parse_http_to_components(request_line)
  puts request_line

  client.puts 'HTTP/1.0 200 OK'
  client.puts 'Content-Type: text/html'
  client.puts
  client.puts '<html>'
  client.puts '<body>'
  client.puts '<pre>'
  client.puts http_method
  client.puts path
  client.puts parameters

  client.puts '<h1>Counter</h1>'
  number = parameters ? parameters['number'].to_i : '** No number supplied! **'
  client.puts "<p>The current number is #{number}.</p>"

  client.puts "<a href='?number=#{number.to_i + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number.to_i - 1}'>Subtract one</a>"

  client.puts '</pre>'
  client.puts '</body>'
  client.puts '</html>'

  client.close
end
# To run program - simply execute this script using $ ruby server.rb
# Then open a browser to localhost:3003?sides=5&rolls=10
# Then in the address bar of the browser type HTTP requests
