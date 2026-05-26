/// Permanently lock Cetus CLMM position NFTs; only trading fees may be withdrawn.
module cetus_lp_locker::locker;

use cetusclmm::config::GlobalConfig;
use cetusclmm::pool::{Self, Pool};
use cetusclmm::position::{Self, Position};
use sui::balance::{Self, Balance};
use sui::coin;
use sui::object::ID;
use sui::transfer;
use sui::tx_context::TxContext;

/// A Cetus position held forever. Liquidity cannot be removed; fees go to `fee_recipient`.
public struct LockedPosition has key {
    id: UID,
    position: Position,
    pool_id: ID,
    fee_recipient: address,
}

const ENotFeeRecipient: u64 = 1;
const EWrongPool: u64 = 2;

/// Deposit a Cetus position NFT. It cannot be retrieved or unwound.
public fun lock_position(
    position: Position,
    fee_recipient: address,
    ctx: &mut TxContext,
) {
    let pool_id = position::pool_id(&position);
    transfer::share_object(LockedPosition {
        id: object::new(ctx),
        position,
        pool_id,
        fee_recipient,
    });
}

/// Harvest accumulated swap fees to `fee_recipient`.
public fun collect_fee<CoinA, CoinB>(
    config: &GlobalConfig,
    pool: &mut Pool<CoinA, CoinB>,
    locked: &LockedPosition,
    ctx: &mut TxContext,
) {
    assert!(tx_context::sender(ctx) == locked.fee_recipient, ENotFeeRecipient);
    assert!(object::id(pool) == locked.pool_id, EWrongPool);

    let (balance_a, balance_b) = pool::collect_fee(
        config,
        pool,
        &locked.position,
        true,
    );
    send_balance<CoinA>(balance_a, locked.fee_recipient, ctx);
    send_balance<CoinB>(balance_b, locked.fee_recipient, ctx);
}

fun send_balance<T>(balance: Balance<T>, recipient: address, ctx: &mut TxContext) {
    if (balance::value(&balance) == 0) {
        balance::destroy_zero(balance);
    } else {
        transfer::public_transfer(coin::from_balance(balance, ctx), recipient);
    };
}
