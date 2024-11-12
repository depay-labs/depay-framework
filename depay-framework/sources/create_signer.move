/// Provides a common place for exporting `create_signer` across the DePay Framework.
///
/// To use create_signer, add the module below, such that:
/// `friend depay_framework::friend_wants_create_signer`
/// where `friend_wants_create_signer` is the module that needs `create_signer`.
///
/// Note, that this is only available within the DePay Framework.
///
/// This exists to make auditing straight forward and to limit the need to depend
/// on account to have access to this.
module depay_framework::create_signer {
    friend depay_framework::account;
    friend depay_framework::depay_account;
    friend depay_framework::coin;
    friend depay_framework::fungible_asset;
    friend depay_framework::genesis;
    friend depay_framework::multisig_account;
    friend depay_framework::object;

    public(friend) native fun create_signer(addr: address): signer;
}
