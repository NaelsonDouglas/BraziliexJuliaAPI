# BraziliexJuliaAPI

This code implements a the [Braziliex exchange API](https://braziliex.com/exchange/api.php) in Julia.

The code was tested in Julia 5.2 and it relies in 3 basic packages.
The code itself install them by the way.

| Package   |      Version      |
|----------|:-------------:|
| Nettle|  v"0.3.0" |
| JSON |  v"0.14.0"     |
| HTTP | v"0.4.3" |


## API
The code mimics the restfull API. So you can use the restful API [documentation](https://braziliex.com/exchange/api.php) to understand how the commands work.The syntax for the commads are as it follows
  
            currencies()
		ticker()
		ticker(market::String)
		orderbook()
		tradebook(market::String)
		orderbook()
		orderbook(market::String)
		tradehistory()
		tradehistory(market::String)
		
		balance()
		complete_balance()
		openorders(market::String)
		tradehistory(market::String)
		depositaddress(currency::String)
		sell(amount::Float64, price::Float64, market::String)
		buy(amount::Float64, price::Float64, market::String)
            cancellorder(order_number::Float64, market::String)
            
## Configuration
To use the private methods you need to get your API key and API secret

They can be found [here](https://braziliex.com/exchange/api_key.php)

Then you must set your keys on the code.
You can do that via terminal with:

  **apisecret = "your secret"**

  **apikey = "your key"**

Or you can hardcode it here and here.
    
