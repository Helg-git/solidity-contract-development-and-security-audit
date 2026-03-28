// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract TransientReentrancyGuard {
    modifier nonReentrant() {
        assembly {
            if tload(0) { revert(0, 0) }
            tstore(0, 1)
        }
        _;
    }
    
    function withdraw() external nonReentrant { /* ... */ }
}
