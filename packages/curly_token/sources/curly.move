// Published mainnet source (immutable).

/// Curly launch token — 1000000000 @ 9 decimals. Coin type: `{package_id}::curly::CURLY`.
module curly::curly {
    use sui::coin_registry;

    /// OTW: module `curly` requires struct `CURLY`.
    public struct CURLY has drop {}

    const DECIMALS: u8 = 9;
    const TOTAL_SUPPLY: u64 = 1000000000000000000;

    fun init(witness: CURLY, ctx: &mut TxContext) {
        let (initializer, mut treasury_cap) = coin_registry::new_currency_with_otw(
            witness,
            DECIMALS,
            b"CRLY".to_string(),
            b"Curly".to_string(),
            b"Curly the Pangolin. Building on Sui Network!".to_string(),
            b"https://ipfs.io/ipfs/bafybeib6ej6sfclbt3wtemfnrfgq5mcvlcuj2gpjmnlvzjhfmp7mcfkugm".to_string(),
            ctx,
        );

        let supply = treasury_cap.mint(TOTAL_SUPPLY, ctx);

        transfer::public_transfer(treasury_cap, ctx.sender());
        transfer::public_transfer(supply, ctx.sender());

        let metadata_cap = initializer.finalize(ctx);
        transfer::public_transfer(metadata_cap, ctx.sender());
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(CURLY {}, ctx);
    }
}
