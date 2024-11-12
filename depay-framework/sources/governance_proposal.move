/// Define the GovernanceProposal that will be used as part of on-chain governance by DePayGovernance.
///
/// This is separate from the DePayGovernance module to avoid circular dependency between DePayGovernance and Stake.
module depay_framework::governance_proposal {
    friend depay_framework::depay_governance;

    struct GovernanceProposal has store, drop {}

    /// Create and return a GovernanceProposal resource. Can only be called by DePayGovernance
    public(friend) fun create_proposal(): GovernanceProposal {
        GovernanceProposal {}
    }

    /// Useful for DePayGovernance to create an empty proposal as proof.
    public(friend) fun create_empty_proposal(): GovernanceProposal {
        create_proposal()
    }

    #[test_only]
    public fun create_test_proposal(): GovernanceProposal {
        create_empty_proposal()
    }
}
