require_relative 'advice'
require_relative 'monroe'

# A Simple Rack Application
class App < Monroe
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      status = '200'
      headers = { 'Content-type' => 'text/html' }
      response(status, headers) do
        erb :index
      end
    when '/advice'
      piece_of_advice = Advice.new.generate
      status = '200'
      headers = { 'Content-Type' => 'text/html' }
      response(status, headers) do
        erb :advice, message: piece_of_advice
      end
    else
      status = '404'
      headers = { 'Content-Type' => 'text/html' }
      response(status, headers) do
        erb :not_found
      end
    end
  end
end
