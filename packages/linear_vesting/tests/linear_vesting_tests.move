#[test_only]
module linear_vesting::linear_vesting_tests;

use linear_vesting::linear_vesting::{Self, new_wallet, Wallet};
use sui::clock;
use sui::coin;
use sui::sui::SUI;
use sui::test_scenario as ts;

const OWNER: address = @0xAAAA;
const FUNDER: address = @0xBBBB;
const AMOUNT: u64 = 10_000;
const START: u64 = 1_000;
const DURATION: u64 = 1_000_000;

fun setup(): ts::Scenario {
    let mut ts = ts::begin(FUNDER);
    let coins = coin::mint_for_testing<SUI>(AMOUNT, ts.ctx());
    let now = clock::create_for_testing(ts.ctx());
    let wallet = new_wallet(coins, &now, START, DURATION, ts.ctx());
    transfer::public_transfer(wallet, OWNER);
    now.destroy_for_testing();
    ts
}

#[test]
#[expected_failure(abort_code = linear_vesting::EInvalidStartTime)]
fun test_invalid_start_time() {
    let mut ts = ts::begin(FUNDER);
    let coins = coin::mint_for_testing<SUI>(AMOUNT, ts.ctx());
    let now = clock::create_for_testing(ts.ctx());
    let wallet = new_wallet(coins, &now, 0, DURATION, ts.ctx());
    transfer::public_transfer(wallet, OWNER);
    now.destroy_for_testing();
    ts::end(ts);
}

#[test]
fun test_linear_vesting() {
    let mut ts = setup();
    ts.next_tx(OWNER);
    let mut now = clock::create_for_testing(ts.ctx());
    let mut wallet = ts.take_from_sender<Wallet<SUI>>();

    now.increment_for_testing(START);
    assert!(wallet.claimable(&now) == 0);
    assert!(wallet.balance() == AMOUNT);

    now.increment_for_testing(DURATION / 2);
    assert!(wallet.claimable(&now) == AMOUNT / 2);
    assert!(wallet.balance() == AMOUNT);
    let coins = wallet.claim(&now, ts.ctx());
    transfer::public_transfer(coins, OWNER);
    assert!(wallet.claimable(&now) == 0);
    assert!(wallet.balance() == AMOUNT / 2);

    now.set_for_testing(START + DURATION);
    assert!(wallet.claimable(&now) == AMOUNT / 2);
    assert!(wallet.balance() == AMOUNT / 2);
    let coins = wallet.claim(&now, ts.ctx());
    transfer::public_transfer(coins, OWNER);
    assert!(wallet.claimable(&now) == 0);
    assert!(wallet.balance() == 0);

    ts.return_to_sender(wallet);
    now.destroy_for_testing();
    let _end = ts::end(ts);
}
