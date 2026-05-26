# Curly mainnet deployments

Verified Move source for both **immutable** mainnet packages.

## Packages

| Package | Package ID | Immutable | Git tag | Verify path |
|---------|------------|-----------|---------|-------------|
| `curly_token` | `0x11722802e68593995109d15923c701186956825396d0983eb7a70788755c28e0` | yes | `curly-token-mainnet-v1` | `packages/curly_token` |
| `cetus_lp_locker` | `0x9179208e023529e0333846e308d01032c49674f5f84c23898a669b04d5f7ac13` | yes | `cetus-lp-locker-mainnet-v1` | `packages/cetus_lp_locker` |

## Coin type

`0x11722802e68593995109d15923c701186956825396d0983eb7a70788755c28e0::curly::CURLY`

## Transactions

| Step | Digest |
|------|--------|
| Token publish | `4m7Yap7kHU7zwHAq3TKBMTZMox25iWHFNqrYyxm8XmDY` |
| Coin registry finalize | `8Cs7U9RpHiox2AYqTebMmNWp3ZAqhPJeQi5j8xYSBoNw` |
| Finalize caps (fixed supply + immutable package) | `H8Zyn7SeEwR1zRTccuLwdBXsk6NogMTXKUUAxmYh3zg4` |
| LP locker publish | `CPuNyBmjuET6RpJcPYrB4FLZ61RD5vkAZA1zV2e2opMa` |

## Explorer links

- [CRLY token package](https://suiscan.xyz/mainnet/object/0x11722802e68593995109d15923c701186956825396d0983eb7a70788755c28e0)
- [LP locker package](https://suiscan.xyz/mainnet/object/0x9179208e023529e0333846e308d01032c49674f5f84c23898a669b04d5f7ac13)

## Build toolchain

| Component | Pin |
|-----------|-----|
| Sui framework | git [MystenLabs/sui](https://github.com/MystenLabs/sui) @ `73dd2c2ba6f9fdb21d7ffde2b50a3f2f0ac39bc1` |
| Cetus CLMM vendor | [CetusProtocol/cetus-clmm-interface](https://github.com/CetusProtocol/cetus-clmm-interface) @ `74e98b69334ecc84fc419d10a59d3d4e1f832d32` |
| IntegerMate | `mainnet-v1.3.0` → `09a12d9b171122883d9350039d4ed6e8400033b9` |
| MoveSTL | `mainnet-v1.3.0` → `0681fec63a310ae753d03a06f7c05d3e2925bb09` |

## Manifest digests (`Move.lock`, mainnet)

| Package | Root manifest digest |
|---------|---------------------|
| `cetus_lp_locker` | `0E281A57259E4A91F92F56DED5A0D1AC4E5ED3FA82A32626DBAD23578C8F558D` |
| `curly_token` | `D102AD9D5653054ABB17E21F853CF4E888E04AB30025D5DAC19DAF483C2B899B` |

These are local build metadata from `Move.lock` (SHA3-256 of each package's `Move.toml`). They are not on-chain identifiers and cannot be searched on Suiscan. The token root manifest digest can differ when `Move.toml` uses git-pinned `Sui` dependencies; **package bytecode still matches** the on-chain immutable package (verified via `sui move build --dump-bytecode-as-base64`).

## Block explorer verification

For each package on Suiscan, submit:

1. This repository's public Git URL
2. Git tag (`curly-token-mainnet-v1` or `cetus-lp-locker-mainnet-v1`)
3. Package subdirectory path (see table above)

Build locally before submitting:

```powershell
cd packages/curly_token
sui move build -e mainnet

cd ../cetus_lp_locker
sui move build -e mainnet
```
