module access_pass::coin {
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self as tx_context, TxContext};
    use std::option;

    // Define the COIN struct, which acts as a one-time witness type.
    struct COIN has drop {}

    // Internal function to create the COIN token with unlimited supply.
    fun init(witness: COIN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<COIN>(
            witness,
            2,
            b"AAP",
            b"All Access Pass",
            b"All Access pass to Gamisodes Platform",
            option::none(),
            ctx
        );
        
        
        // Consume the metadata by transferring it to an address (e.g., burn address) or another operation.
        let burn_address: address = @0x0;
        transfer::public_transfer(metadata, burn_address);

        // Transfer the treasury cap (minting capability) to the sender.
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
    }

    // Simple function to mint a new access pass token.
    public fun mint(
        treasury_cap: &mut TreasuryCap<COIN>, 
        amount: u64, 
        ctx: &mut TxContext
    ): Coin<COIN> {
        coin::mint(treasury_cap, amount, ctx)
    }

    // Entry function to mint and immediately transfer the access pass token.
    public entry fun mint_and_transfer(
        treasury_cap: &mut TreasuryCap<COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx);
    }

    // Entry function to transfer an existing access pass token.
    public entry fun transfer(
        coin: Coin<COIN>, 
        recipient: address
    ) {
        transfer::public_transfer(coin, recipient);
    }

    // Simple function to burn (destroy) the access pass token.
    public entry fun burn(
        treasury_cap: &mut TreasuryCap<COIN>, 
        coin: Coin<COIN>
    ) {
        coin::burn(treasury_cap, coin);
    }
}
