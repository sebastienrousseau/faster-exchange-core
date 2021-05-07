<!-- markdownlint-disable MD002 -->
<!-- markdownlint-disable MD012 -->
<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD041 -->
<p align="center">
  <a href="/" title="Faster Exchange Logo">
    <img src="faster-exchange.svg" alt="" width="150" height="150" alt="Faster Exchange Logo" />
  </a>

  # Faster Exchange

  ## Building the High-Performance Transaction Credits Platform

  The Faster Exchange Ethereum Smart Contracts aims to provide a decentralised financial suite that allows delivery of global financial services via a distributed ledger, self-executing smart contracts, and cryptocurrency.

- [Faster Exchange](#faster-exchange)
  - [Building the High-Performance Transaction Credits Platform](#building-the-high-performance-transaction-credits-platform)
  - [Setup](#setup)
  - [Testing](#testing)
    - [Contributing](#contributing)
    - [Code of Conduct](#code-of-conduct)
    - [License](#license)
    - [Acknowledgments](#acknowledgments)

## Setup

The smart contracts are written in [Solidity][solidity] and tested/deployed
using [Truffle](https://www.trufflesuite.com) v5.3.4 (core: 5.3.4)
[Node](https://nodejs.org) v16.1.0. 

```bash
# Install Truffle package globally:
$ npm install -g truffle

# Install local node dependencies:
$ npm install || yarn
```
## Testing

To test the code simply run:

```bash
# Running tests:
$ npm run test || yarn test
```

### Contributing

Please read carefully through our [Contributing Guidelines](https://github.com/sebastienrousseau/faster-exchange-core/blob/master/CONTRIBUTING.md) for further details on the process for submitting pull requests to us.

### Code of Conduct

We are committed to preserving and fostering a diverse, welcoming community. Please read our [Code of Conduct](https://github.com/sebastienrousseau/faster-exchange-core/blob/master/CODE_OF_CONDUCT.md).

### License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/sebastienrousseau/faster-exchange-core/blob/master/LICENSE) file for details

### Acknowledgments

[Faster Exchange](https://fasterexchange.network) is beautifully crafted by these people and a bunch of awesome [contributors](https://github.com/sebastienrousseau/faster-exchange-core/graphs/contributors)

[![Sebastien Rousseau](https://avatars0.githubusercontent.com/u/1394998?s=117)](http://sebastienrousseau.co.uk) 


[Sebastien Rousseau](https://github.com/sebastienrousseau) 
 

Faster Exchange is maintained and funded by Sebastien Rousseau.

[faster-exchange-core]: https://fasterexchange.network
[ethereum]: https://www.ethereum.org/
[solidity]: https://solidity.readthedocs.io/en/develop/
[truffle]: http://truffleframework.com/
[testrpc]: https://github.com/ethereumjs/testrpc
