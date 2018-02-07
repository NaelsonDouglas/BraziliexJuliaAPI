Pkg.add("Nettle")
Pkg.add("HTTP")
Pkg.add("JSON")


using Nettle
using HTTP
using JSON

#Invalid key bug ---> https://github.com/JuliaWeb/Requests.jl/issues/52

privateurl = "https://braziliex.com/api/v1/private"
publicurl = "https://braziliex.com/api/v1/public/"


apisecret = "empty"
apikey = "empty"

function documentation()

print_with_color(:blue, "
		=================================================\n")
print_with_color(:green,"				     BRAZIL")
print_with_color(:yellow,"I")
print_with_color(:blue,"EX")	
	print_with_color(:yellow, "
		=================================================\n")
	print_with_color(:green, "
		      Welcome to the Brazilex Julia API.\n\n")
	print("		
		To start using it you need to set 2 variables\n
		apikey\n
		apisecret\n\n
		To get your API key and secret you must follow the link:\n
		https://braziliex.com/exchange/api_key.php\n\n
		after that you need to set them with the following commands:\n
		**For the key\n
		apikey = \"your api key goes here\"\n
		apisecret = \"your api secret goes here\"\n

		Then that you are ready to go. 
		The avaliable commands are wrappers on the restfull API \(https://braziliex.com/exchange/api.php\)
		The commands are as follows:
		")	

	print_with_color(:green, "
		      **Public methods. These will work even without a proper key/secret**
		currencies()
		ticker()
		ticker(market::String)
		orderbook()
		tradebook(market::String)
		orderbook()
		orderbook(market::String)
		tradehistory()
		tradehistory(market::String)

		**Private methods. These won't work without key/secret**
		balance()
		complete_balance()
		openorders(market::String)
		tradehistory(market::String)
		depositaddress(currency::String)
		sell(amount::Float64, price::Float64, market::String)
		buy(amount::Float64, price::Float64, market::String)
		cancellorder(order_number::Float64, market::String)
		\n\n")
end



function privaterequest(command::String;secret::String=apisecret, key::String=apikey)


	nonce = time()
	bodydata = string("nonce=",nonce,"&command=",command)

	cipheredbodydata = hexdigest("sha512",secret,bodydata)

	headersdata = Dict("key"=>key, "sign"=>cipheredbodydata,"Content-Type" => "application/x-www-form-urlencoded")
	HTTP.post(privateurl,headers=headersdata,body=bodydata)

	if (secret == "empty")
		print_with_color(:red,"========================================================================\n")		
		print_with_color(:blue,"            YOU NEED TO SET YOUR API KEY AND API SECRET.\n")		
		print_with_color(:blue,"           you can check how to to it by calling documentation().\n")
		print_with_color(:red,"========================================================================\n")		
	end
end

function balance()
	privaterequest("balance")
end

function openorders(market::String="")
	command = string("open_orders&market=",market)
	privaterequest(command)
end

function tradehistory(market::String="")
	command = string("trade_history&market=",market)
	privaterequest(command)
end


function depositaddress(currency::String)
	cmd = "deposit_address&"
	curr = string("currency=",currency)
	command = string(cmd,curr)	
	privaterequest(command)
end


#when using it, you must call sell(1.0,1.0,market). Never forget the dot after the number. For julia "1" is an integer and 1.0 is a float. If you put an integer, the function call will bug
function sell(amount::Float64, price::Float64, market::String)
	cmd = "sell&"
	amt = string("amount=",amount,"&")
	prc = string("price=",price,"&")
	mkt = string("market=",market)
	command = string(cmd,amt,prc,mkt)	
	privaterequest(command)
end

#when using it, you must call buy(1.0,1.0,market). Never forget the dot after the number. For julia "1" is an integer and 1.0 is a float. If you put an integer, the function call will bug
function buy(amount::Float64, price::Float64, market::String)
	cmd = "buy&"
	amt = string("amount=",amount,"&")
	prc = string("price=",price,"&")
	mkt = string("market=",market)
	command = string(cmd,amt,prc,mkt)	
	privaterequest(command)
end

function cancellorder(order_number::Float64, market::String)
	cmd = "cancel_order&"
	order_number = string("order_number=",order_number,"&")
	mkt = string("market=",market)
	command = string(cmd,order_number,mkt)	
	privaterequest(command)
end

function publicrequest(command::String)
	request = string(publicurl,command)
	JSON.parse(String(HTTP.get(request)))
end

function currencies()
	publicrequest("currencies")
end

function ticker(market::String="")
	request = string("ticker/",market)
	publicrequest(request)
end

function orderbook(market::String="")
	request = string("orderbook/",market)
	publicrequest(request)
end

function tradehistory(market::String="")
	request = string("tradehistory/",market)
	publicrequest(request)
end



documentation()
