// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ArrayReverse {
    function reverse(uint256[] memory arr)
        internal pure returns (uint256[] memory)
    {
        assembly ("memory-safe") {
            let len := mload(arr)
            let dataPtr := add(arr, 32)
            let endPtr := add(dataPtr, mul(len, 32))

            for { let i := dataPtr } lt(i, sub(endPtr, 32)) { i := add(i, 32) } {
                let j := sub(endPtr, sub(i, dataPtr))
                let tmp := mload(i)
                mstore(i, mload(j))
                mstore(j, tmp)
            }
        }
        return arr;
    }
}
