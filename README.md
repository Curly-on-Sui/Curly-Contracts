# Curly-Contracts

Verified Move source for **Curly (CRLY)** on Sui mainnet:

- **`curly_token`** — OTW coin via `coin_registry` (1B CRLY, 9 decimals). Package is immutable; supply is fixed.
- **`cetus_lp_locker`** — Permanently locks Cetus CLMM position NFTs; only swap fees can be collected by the designated recipient. Package is immutable.
- **`linear_vesting`** — Generic linear vesting wallet (`new_wallet`, `claim`, `claimable`) for any `Coin<T>`. Move source in `packages/linear_vesting`.

This repository contains Move source for block explorer verification of on-chain mainnet packages.

## Layout

```text
packages/
  curly_token/       CRLY token (mainnet)
  cetus_lp_locker/   Cetus LP locker (mainnet)
  linear_vesting/    Linear vesting wallet
releases/mainnet/    Move.toml snapshots used at mainnet publish
```

See [DEPLOYMENTS.md](DEPLOYMENTS.md) for live mainnet package IDs and verification links.

## Build

Requires [Sui CLI](https://docs.sui.io) compatible with framework rev `73dd2c2ba6f9fdb21d7ffde2b50a3f2f0ac39bc1` (see DEPLOYMENTS.md).

```powershell
cd packages/curly_token
sui move build -e mainnet

cd ../cetus_lp_locker
sui move build -e mainnet

cd ../linear_vesting
sui move build -e mainnet
sui move test -e mainnet
```

Do not commit `build/` output, `dist/` scratch builds, or local Sui client config (see `.gitignore`).

## Verify on Suiscan

1. Open the package page on [Suiscan mainnet](https://suiscan.xyz/mainnet).
2. Use “Verify source” (or equivalent) with:
   - This repository's public Git URL
   - Tag: see table below
   - Path: `packages/<package_name>`

## Tags

| Tag | Package |
|-----|---------|
| `curly-token-mainnet-v1` | `0x11722802…::curly` |
| `cetus-lp-locker-mainnet-v1` | `0x9179208e…` locker |
| `mainnet-v1` | Token + locker (same commit) |

## Security

This repo is intended for **public** release: mainnet verified source only. Do not commit private keys, keystores, `.env` files, local filesystem paths in `Move.toml`, or `build/` / `dist/` output (see `.gitignore`).

Operational deploy tooling lives in the private `sui_launches` repo, not here.
