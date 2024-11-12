#[test_only]
module depay_framework::depay_coin_tests {
    use depay_framework::depay_coin;
    use depay_framework::coin;
    use depay_framework::fungible_asset::{Self, FungibleStore, Metadata};
    use depay_framework::primary_fungible_store;
    use depay_framework::object::{Self, Object};

    public fun mint_dpt_fa_to_for_test<T: key>(store: Object<T>, amount: u64) {
        fungible_asset::deposit(store, depay_coin::mint_dpt_fa_for_test(amount));
    }

    public fun mint_dpt_fa_to_primary_fungible_store_for_test(
        owner: address,
        amount: u64,
    ) {
        primary_fungible_store::deposit(owner, depay_coin::mint_dpt_fa_for_test(amount));
    }

    #[test(depay_framework = @depay_framework)]
    fun test_dpt_setup_and_mint(depay_framework: &signer) {
        let (burn_cap, mint_cap) = depay_coin::initialize_for_test(depay_framework);
        let coin = coin::mint(100, &mint_cap);
        let fa = coin::coin_to_fungible_asset(coin);
        primary_fungible_store::deposit(@depay_framework, fa);
        assert!(
            primary_fungible_store::balance(
                @depay_framework,
                object::address_to_object<Metadata>(@depay_fungible_asset)
            ) == 100,
            0
        );
        coin::destroy_mint_cap(mint_cap);
        coin::destroy_burn_cap(burn_cap);
    }

    #[test]
    fun test_fa_helpers_for_test() {
        assert!(!object::object_exists<Metadata>(@depay_fungible_asset), 0);
        depay_coin::ensure_initialized_with_dpt_fa_metadata_for_test();
        assert!(object::object_exists<Metadata>(@depay_fungible_asset), 0);
        mint_dpt_fa_to_primary_fungible_store_for_test(@depay_framework, 100);
        let metadata = object::address_to_object<Metadata>(@depay_fungible_asset);
        assert!(primary_fungible_store::balance(@depay_framework, metadata) == 100, 0);
        let store_addr = primary_fungible_store::primary_store_address(@depay_framework, metadata);
        mint_dpt_fa_to_for_test(object::address_to_object<FungibleStore>(store_addr), 100);
        assert!(primary_fungible_store::balance(@depay_framework, metadata) == 200, 0);
    }
}
