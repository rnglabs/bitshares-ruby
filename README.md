# Bitshares 2.0 (Graphene) Ruby Gem

This Gem provides a Ruby API for BitShares Remote Procedure Calls.

Use it with a public RPC server to access the
[Blockchain API](http://docs.bitshares.org/api/blockchain-api.html).

Or configure an account with a local wallet to access the
[Wallet API](http://docs.bitshares.org/api/wallet-api.html).

Wallet should be installed and running, RPC port should be locally
accessible and credentials should be provided for the Wallet API to
work.

## Requirements

**Blockchain API** should work with public RPCs without any requirement.

**Wallet API** requires the [CLI Wallet](http://docs.bitshares.org/integration/apps/cliwallet.html) to be installed and running.

## Installation

_@TODO not in rubygems yet_

## Configuration

RPC server login credentials can be configured with a hash:

```ruby
  Bithares.configure({
      rpc: {
        username: nil,
        password: nil,
        server: 'http://127.0.0.1:8090/' },
      wallet: {
        name:nil,
        password: nil } })
```

You can also use [environment vars or a yaml file](wiki/Configuration).

## Usage

### Quick start

```ruby
require 'bitshares'

# Init RPC client and check RPC status
# Default configuration is Local RPC no credentials
# _Will throw exception if RPC is not up!_
bts = Bithares.init
```
Any valid client command can then be issued via a method call with relevant
parameters - e.g.

```ruby
witnesses_ids = bts.lookup_witness_accounts('',100).collect(&:last)
bts.get_witnesses([witnesses_ids])
...
```

Data is returned as a hash

###  Convenience methods

Just open a ruby console and start hacking away.

_Note all gem methods accept names (for accounts and assets) as parameters
instead of ids. You can still call the RPCAPI methods directly with ids if you
want to._

```ruby
require 'bitshares'

# Configure openledger public RPC and init.
bts = Bitshares.openledger
bts.get_chain_id
eth_bts = bts.market('eth','bts')
eth_bts.mid_price

# Configure testnet public RPC and init.
bts = Bitshares.testnet
bts.get_chain_id
```

### Detailed usage

#### Blockchain

See http://docs.bitshares.org/api/blockchain-api.html

```Ruby
bts = Bitshares.openledger
count = bts.get_block_count
a_bts, a_usd, a_cny = bts.assets(['bts','usd','cny'])
```

#### Wallet

**Wallet API currently untested**

See http://docs.bitshares.org/api/wallet-api.html

```Ruby
Bitshares.configure({
    wallet: {
      name: "AccountName",
      password: "P4ssw0rd" } })
bts = Bitshares.init
```

Now you can call Wallet API methods by name:

```Ruby
bts.wallet.vote_for_witness('test-account','rnglab',true)
```

#### Market

The market class represents the trading (order book and history) for a given an
asset-pair - e.g. CNY/BTS. It is instantiated like this:

```Ruby
cny_bts = bts.market('CNY', 'BTS')
```

_Note that the BitShares market convention is that quote asset_id > base asset_id.
Reversing the symbols in the above example results in the client returning  an
'Invalid Market' error._ An asset's id can be found from the asset hash by using:

```Ruby
cny = bts.assets('CNY').first
```

The following methods may then be used without specifying the quote and base
assets again, allowing other optional arguments the client accepts:

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

#### Account

The account class represents any bitshares account. It is instantiated like this:

```Ruby
account = bts.account('accountname')
```

_Note you must check for account existance with the valid? method._

The following methods may then be used without specifying the account id/name
again, allowing other optional arguments the client accepts:

```Ruby
account.get_workers
account.get_witness
account.get_vesting_balances
account.get_proposed_transactions
account.get_margin_positions
account.get_committee_member
account.references
account.balances(assets=[])
```

Method rename convention is:

* If the RPC-API method name starts with get_account_ remove it.
ie. get_account_references becomes account.references
* If the RPC-API method ends with _by_account remove it.
ie. get_witness_by_account becomes account.get_witness

#### Specification & tests

For the full specification clone this repo and run:

`rake spec`

**Test Requirements**

_@TODO test wallet methods in testnet._

## Contributing

Bug reports, pull requests (and feature requests) are welcome on GitHub at https://github.com/MatzFan/bitshares-ruby.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
