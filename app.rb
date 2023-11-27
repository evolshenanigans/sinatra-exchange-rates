require "sinatra"
require "sinatra/reloader"
require "http"



get ("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATE_KEY']}"
  response = HTTP.get(api_url)
    response_string = response.to_s
    parsed_data = JSON.parse(response)
    @currencies = parsed_data['currencies'].keys.sort
    erb :index
end

get("/:currency") do
  @original_currency = params[:currency]
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATE_KEY']}"
  response = HTTP.get(api_url)
  parsed_data = JSON.parse(response.to_s)
  @currencies = parsed_data['currencies'].keys.sort - [@original_currency]
  erb :currency_conversion
end

get("/:from_currency/:to_currency") do
  @from_currency = params[:from_currency]
  @to_currency = params[:to_currency]

  api_url = "https://api.exchangerate.host/convert?from=#{@from_currency}&to=#{@to_currency}&amount=1&access_key=#{ENV['EXCHANGE_RATE_KEY']}"
  response = HTTP.get(api_url)
  result = JSON.parse(response.to_s)

  if result["success"]
    @converted_amount = result["result"]
  else
    @error_message = result["error"] || "Unable to fetch conversion data."
  end

  erb :conversion_result
end

