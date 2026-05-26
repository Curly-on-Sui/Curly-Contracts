# Curly-Contracts

Verified Move source for **Curly (CRLY)** on Sui mainnet:

- **`curly_token`** — OTW coin via `coin_registry` (1B CRLY, 9 decimals). Package is immutable; supply is fixed.
- **`cetus_lp_locker`** — Permanently locks Cetus CLMM position NFTs; only swap fees can be collected by the designated recipient.

This repository contains Move source for block explorer verification of the on-chain packages.

## Layout

```text
packages/
  curly_token/       CRLY token (mainnet)
  cetus_lp_locker/   Cetus LP locker (mainnet)
releases/mainnet/    Move.toml snapshots used at publish
```

See [DEPLOYMENTS.md](DEPLOYMENTS.md) for package IDs, transaction digests, dependency pins, and Suiscan links.

## Build

Requires [Sui CLI](https://docs.sui.io) compatible with framework rev `73dd2c2ba6f9fdb21d7ffde2b50a3f2f0ac39bc1` (see DEPLOYMENTS.md).

```powershell
cd packages/curly_token
sui move build -e mainnet

cd ../cetus_lp_locker
sui move build -e mainnet
```

Do not commit `build/` output or local Sui client config (see `.gitignore`).

## Verify on Suiscan

1. Open the package page on [Suiscan mainnet](https://suiscan.xyz/mainnet).
2. Use “Verify source” (or equivalent) with:
   - This repository's public Git URL
   - Tag: `curly-token-mainnet-v1` or `cetus-lp-locker-mainnet-v1`
   - Path: `packages/curly_token` or `packages/cetus_lp_locker`

## Tags

| Tag | Package |
|-----|---------|
| `curly-token-mainnet-v1` | `0x11722802…::curly` |
| `cetus-lp-locker-mainnet-v1` | `0x9179208e…` locker |
| `mainnet-v1` | Both packages (same commit) |
