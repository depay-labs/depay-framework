spec depay_framework::dkg {

    spec module {
        use depay_framework::chain_status;
        invariant [suspendable] chain_status::is_operating() ==> exists<DKGState>(@depay_framework);
    }

    spec initialize(depay_framework: &signer) {
        use std::signer;
        let depay_framework_addr = signer::address_of(depay_framework);
        aborts_if depay_framework_addr != @depay_framework;
    }

    spec start(
        dealer_epoch: u64,
        randomness_config: RandomnessConfig,
        dealer_validator_set: vector<ValidatorConsensusInfo>,
        target_validator_set: vector<ValidatorConsensusInfo>,
    ) {
        aborts_if !exists<DKGState>(@depay_framework);
        aborts_if !exists<timestamp::CurrentTimeMicroseconds>(@depay_framework);
    }

    spec finish(transcript: vector<u8>) {
        use std::option;
        requires exists<DKGState>(@depay_framework);
        requires option::is_some(global<DKGState>(@depay_framework).in_progress);
        aborts_if false;
    }

    spec fun has_incomplete_session(): bool {
        if (exists<DKGState>(@depay_framework)) {
            option::spec_is_some(global<DKGState>(@depay_framework).in_progress)
        } else {
            false
        }
    }

    spec try_clear_incomplete_session(fx: &signer) {
        use std::signer;
        let addr = signer::address_of(fx);
        aborts_if addr != @depay_framework;
    }

    spec incomplete_session(): Option<DKGSessionState> {
        aborts_if false;
    }
}
