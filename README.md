# daotic

degen dao with frens on lens

## CONTRIBUTION DAO

Yoo degen
Don't push to main.
Push to develop and hack your feature on feat/featname....

## Roadmap

=> Set out Roadmap
=> Tech & Protocol Research
=> Governance Setup & Research

0. List requirements
1. Agree on Stack & Chain
2. Set functionality
3. Hack, Test & develop
4. Hack, Test & develop
5. MVP version 1 done! **27.9.23**

## Ideas on Tech and Stack

- Lens
- Zodiac SAFE
- SAFE
- POAP
- Polygon
- Snapshot
- Colony
- Aragon OSX
- Moloch DAO
- Commonwealth
- O.Z. Stack
- Tenderly Sim
- Otoco
- Consensys Dilligence
-

## Setup

We're running on a Foundry x Hardhat project and use the following remappings:

@std/=lib/forge-std/src/
@oz/=lib/openzeppelin-contracts/contracts/

Be aware that Foundry uses git submodules for it's dependency tree, so please use

```
git checkout ... -recursive
```

## Getting Started

This is a list of the most frequently needed commands.

### Build

Build the contracts:

```sh
$ forge build
```

### Clean

Delete the build artifacts and cache directories:

```sh
$ forge clean
```

### Compile

Compile the contracts:

```sh
$ forge build
```

### Coverage

Get a test coverage report:

```sh
$ forge coverage
```

### Deploy

```
make deploy ARGS="--network sepolia"
```

More commands can be found in `Makefile`

### Format

Format the contracts:

```sh
$ forge fmt
```

### Gas Usage

Get a gas report:

```sh
$ forge test --gas-report
```

Generate gas snapshot

```sh
$ forge snapshot --snap gas-snapshots/.gas-snapshot-[current Date (12092023)]
```

### Lint

Lint the contracts:

```sh
$ yarn lint
```

```sh
$ slither .
```

### Test

Run the tests:

```sh
$ forge test
```

## License

This project is licensed under MIT.
