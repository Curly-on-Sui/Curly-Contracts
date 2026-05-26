// Linear token vesting — aligned with Sui's official example.
// Docs: https://docs.sui.io/onchain-finance/fungible-tokens/token-vesting-strategies
// Reference: https://github.com/MystenLabs/sui/blob/main/examples/vesting/sources/linear.move

/// Coins unlock linearly from `start` over `duration` (ms, from `sui::clock::Clock`).
module linear_vesting::linear_vesting;

use sui::balance::Balance;
use sui::clock::Clock;
use sui::coin::{Self, Coin};

// === Errors ===

#[error]
const EInvalidStartTime: vector<u8> = b"Start time must be in the future.";

// === Structs ===

/// [Owned] Wallet contains coins that are available for claiming over time.
public struct Wallet<phantom T> has key, store {
    id: UID,
    balance: Balance<T>,
    start: u64,
    claimed: u64,
    duration: u64,
}

// === Public Functions ===

/// Create a wallet with the given coins, vesting `start`, and `duration`.
/// Full amount is stored up front; coins are claimed over time via `claim`.
public fun new_wallet<T>(
    coins: Coin<T>,
    clock: &Clock,
    start: u64,
    duration: u64,
    ctx: &mut TxContext,
): Wallet<T> {
    assert!(start > clock.timestamp_ms(), EInvalidStartTime);
    Wallet {
        id: object::new(ctx),
        balance: coins.into_balance(),
        start,
        claimed: 0,
        duration,
    }
}

/// Claim coins available at the current time.
public fun claim<T>(wallet: &mut Wallet<T>, clock: &Clock, ctx: &mut TxContext): Coin<T> {
    let claimable_amount = wallet.claimable(clock);
    wallet.claimed = wallet.claimed + claimable_amount;
    coin::from_balance(wallet.balance.split(claimable_amount), ctx)
}

/// Amount of coins that can be claimed at the current time.
public fun claimable<T>(wallet: &Wallet<T>, clock: &Clock): u64 {
    let timestamp = clock.timestamp_ms();
    if (timestamp < wallet.start) return 0;
    if (timestamp >= wallet.start + wallet.duration) return wallet.balance.value();
    let elapsed = timestamp - wallet.start;
    let claimable: u128 =
        (wallet.balance.value() + wallet.claimed as u128) * (elapsed as u128) / (wallet.duration as u128);
    (claimable as u64) - wallet.claimed
}

/// Delete the wallet if it is empty.
public fun delete_wallet<T>(wallet: Wallet<T>) {
    let Wallet { id, start: _, balance, claimed: _, duration: _ } = wallet;
    id.delete();
    balance.destroy_zero();
}

// === Accessors ===

public fun balance<T>(wallet: &Wallet<T>): u64 {
    wallet.balance.value()
}

public fun start<T>(wallet: &Wallet<T>): u64 {
    wallet.start
}

public fun duration<T>(wallet: &Wallet<T>): u64 {
    wallet.duration
}
