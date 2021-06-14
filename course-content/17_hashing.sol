/*
Solidity provides inbuilt cryptographic functions as well.

Following are important methods:

1. keccak256(bytes memory) returns (bytes32) − computes the Keccak-256 hash of the input.
2. sha256(bytes memory) returns (bytes32) − computes the SHA-256 hash of the input.
3. ripemd160(bytes memory) returns (bytes20) − compute RIPEMD-160 hash of the input.
4. sha256(bytes memory) returns (bytes32) − computes the SHA-256 hash of the input.
5. ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address) −
    recover the address associated with the public key from elliptic curve signature or return zero on error.
    The function parameters correspond to ECDSA values of the signature:
    r - first 32 bytes of signature;
    s: second 32 bytes of signature;
    v: final 1 byte of signature.

    This method returns an address.
*/
