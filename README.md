# Bitshares 2.0 (Graphene) Ruby Gem

This Gem provides a Ruby API for BitShares Remote Procedure Calls.

Use it with a public RPC server to access the
[Blockchain API](http://docs.bitshares.org/api/blockchain-api.html).

Or configure an account with a local wallet to access the
[Wallet API](http://docs.bitshares.org/api/wallet-api.html)

Wallet should be installed and running, RPC port should be locally
accessible and credentials should be provided for the Wallet API to
work.

## Requirements

Blockchain API should work with public RPCs without any requirement.

Wallet API requires the [CLI Wallet](http://docs.bitshares.org/integration/apps/cliwallet.html) to be installed and running.

## Installation

@TODO rubygems has the version for Bitshares 1.0

## Configuration

RPC server login credentials can be configured with a hash:

```ruby
  Bithares.configure({
      rpc_username: nil,
      rpc_password: nil,
      rpc_server: 'http://127.0.0.1:8090/',
      wallet: nil })
```

@TODO move to config details doc page

Or stored in the following **environment variables**:

  `$BITSHARES_ACCOUNT`

  `$BITSHARES_PASSWORD`

__Environment variables override other configuration methods.__

From a **yaml configuration file**

```Ruby
Bitshares.configure_with 'path-to-yaml-file'
```

## Usage

### Quick start

```ruby
require 'bitshares'

# Default configuration is local RPC no credentials
# Bithares.configure({
#     rpc_username: nil,
#     rpc_password: nil,
#     rpc_server: 'http://127.0.0.1:8090/',
#     wallet: nil })

client = CLIENT.init # Init RPC client and chck RPC status
```
Any valid client command can then be issued via a method call with relevant parameters - e.g.

```ruby
chain = Bitshares::Blockchain.new
witnesses_ids = chain.lookup_witness_accounts('',100).collect(&:last)
chain.get_witnesses([witnesses_ids])
...
```

Data is returned as a hash

###  Convenience methods

Just open a ruby console and start hacking away.

```ruby
require 'bitshares'

# Configure openledger public RPC and init.
c = Bitshares.openledger
c.get_chain_id
eth_bts = Bitshares::Market.new('eth','bts')
eth_bts.mid_price

# Configure testnet public RPC and init.
c = Bitshares.testnet
c.get_chain_id
```
### Detailed usage

#### Blockchain

See http://docs.bitshares.org/api/blockchain-api.html

```Ruby
chain = Bitshares::Blockchain.new
count = chain.get_block_count
bts, usd, cny = chain.assets(['bts','uSd','CNY'])
```

#### Wallet

**Wallet API currently untested**

See http://docs.bitshares.org/api/wallet-api.html

```Ruby
wallet = Bitshares::Wallet.new 'wallet1' # opens a wallet available on this client.
```
Note that the following command opens the named wallet, but does not return an instance of Wallet class - use Wallet.new
```Ruby
wallet.open 'wallet1'
```

Thereafter 'wallet_' commands may be issued like this:
```Ruby
wallet.get_info # gets info on this wallet, equivalent to client.wallet_get_info
wallet.transfer(amount, asset, from, recipient) # equivalent to - you get the picture..
```
A wallet is unlocked and closed in a similar fashion:
```Ruby
wallet.unlock
wallet.close
```

Predicates are provided for convenience:
```Ruby
wallet.open?
wallet.unlocked?
```

**Account**

Once you have a wallet instance you can do the following, which references a particular wallet account:
```Ruby
account = wallet.account 'account_name'
```
Thereafter all 'wallet_account_' client commands may be issued without specifying the account_name parameter:
```Ruby
account.balance # balance for a particular account
account.order_list # optional [limit] param
account_register(pay_from_account [, optional params]) # this command takes up to 3 optional params
```
'wallet_account_' client commands taking an *optional* account_name parameter list all data for all of a wallet's accounts. If this is required, the relevant Wallet method should be used - e.g:
```Ruby
wallet.account_balance # lists the balances for all accounts for this wallet (c.c. above)
```

**Market**

The market class represents the trading (order book and history) for a given an
asset-pair - e.g. CNY/BTS. It is instantiated like this:
```Ruby
cny_bts = Bitshares::Market.new('CNY', 'BTS')
```
_Note that the BitShares market convention is that quote asset_id > base asset_id. Reversing the symbols in the above example results in the client returning  an 'Invalid Market' error._ An asset's id can be found from the asset hash by using:
```Ruby
Bitshares::Blockchain.asset 'CNY' # for example
```

The following 'blockchain_market_' client methods may then be used without specifying the quote and base assets again, but with any other optional args the client accepts:

```Ruby
cny_bts.ticker
cny_bts.lowest_ask
cny_bts.highest_bid
cny_bts.mid_price
cny_bts.order_book(limit=50)
cny_bts.limit_orders(limit=50)
cny_bts.trade_history(since=nil,to=nil,limit=100)
cny_bts.get_24_volume

```

**Trading**

Unported

## Specification & tests

For the full specification clone this repo and run:

`rake spec`

**Test Requirements**

@TODO test wallet methods in testnet.

## Contributing

Bug reports, pull requests (and feature requests) are welcome on GitHub at https://github.com/MatzFan/bitshares-ruby.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
