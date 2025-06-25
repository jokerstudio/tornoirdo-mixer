// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IHasher {
    function hash2(uint256 left, uint256 right) external view returns (uint256);
}

contract MerkleTreeWithHistory {
    uint256 public constant FIELD_SIZE = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    uint256 public constant ZERO_VALUE = 21663839004416932945382355908790599225266501822907911457504978515578255421292; // = keccak256("tornado") % FIELD_SIZE
    IHasher public immutable hasher;

    uint32 public levels;

    // the following variables are made public for easier testing and debugging and
    // are not supposed to be accessed in regular code

    // filledSubtrees and roots could be bytes32[size], but using mappings makes it cheaper because
    // it removes index range check on every interaction
    mapping(uint256 => bytes32) public filledSubtrees;
    mapping(uint256 => bytes32) public roots;
    uint32 public constant ROOT_HISTORY_SIZE = 20;
    uint32 public currentRootIndex = 0;
    uint32 public nextIndex = 0;

    constructor(uint32 _levels, IHasher _hasher) {
        require(_levels > 0, "_levels should be greater than zero");
        require(_levels < 32, "_levels should be less than 32");
        levels = _levels;
        hasher = _hasher;

        for (uint32 i = 0; i < _levels; i++) {
            filledSubtrees[i] = zeros(i);
        }

        roots[0] = zeros(_levels - 1);
    }

    /**
     * @dev Hash 2 tree leaves, returns MiMC(_left, _right)
     */
    function hashLeftRight(IHasher _hasher, bytes32 _left, bytes32 _right) public view returns (bytes32) {
        require(uint256(_left) < FIELD_SIZE, "_left should be inside the field");
        require(uint256(_right) < FIELD_SIZE, "_right should be inside the field");
        return bytes32(_hasher.hash2(uint256(_left), uint256(_right)));
    }

    function _insert(bytes32 _leaf) internal returns (uint32 index) {
        uint32 _nextIndex = nextIndex;
        require(_nextIndex != uint32(2) ** levels, "Merkle tree is full. No more leaves can be added");
        uint32 currentIndex = _nextIndex;
        bytes32 currentLevelHash = _leaf;
        bytes32 left;
        bytes32 right;

        for (uint32 i = 0; i < levels; i++) {
            if (currentIndex % 2 == 0) {
                left = currentLevelHash;
                right = zeros(i);
                filledSubtrees[i] = currentLevelHash;
            } else {
                left = filledSubtrees[i];
                right = currentLevelHash;
            }
            currentLevelHash = hashLeftRight(hasher, left, right);
            currentIndex /= 2;
        }

        uint32 newRootIndex = (currentRootIndex + 1) % ROOT_HISTORY_SIZE;
        currentRootIndex = newRootIndex;
        roots[newRootIndex] = currentLevelHash;
        nextIndex = _nextIndex + 1;
        return _nextIndex;
    }

    /**
     * @dev Whether the root is present in the root history
     */
    function isKnownRoot(bytes32 _root) public view returns (bool) {
        if (_root == 0) {
            return false;
        }
        uint32 _currentRootIndex = currentRootIndex;
        uint32 i = _currentRootIndex;
        do {
            if (_root == roots[i]) {
                return true;
            }
            if (i == 0) {
                i = ROOT_HISTORY_SIZE;
            }
            i--;
        } while (i != _currentRootIndex);
        return false;
    }

    /**
     * @dev Returns the last root
     */
    function getLastRoot() public view returns (bytes32) {
        return roots[currentRootIndex];
    }

    /// @dev provides Zero (Empty) elements for a Poseidon MerkleTree. Up to 32 levels
    function zeros(uint256 i) public pure returns (bytes32) {
        if (i == 0) return bytes32(0x2fe54c60d3acabf3343a35b6eba15db4821b340f76e741e2249685ed4899af6c);
        else if (i == 1) return bytes32(0x23a68130b6eaf098ac9787f6db712fedac1a6e61131b8f1910882fd97ac9640c);
        else if (i == 2) return bytes32(0x104e499fe6e3a6db4c5d162e5bbadafa710350a88e9597f2ef9c7676df71f105);
        else if (i == 3) return bytes32(0x2f2b87271d226b4b46711b9678d3c7a6bb062e97c2f689132da519ca98dc8366);
        else if (i == 4) return bytes32(0x201d1cdf7deef2edc5c0a29ca0be2a090bd67ba8d9af89c3ab346a41c3695ae8);
        else if (i == 5) return bytes32(0x1ada60ac49b96655764cd021f0841f0d44e6c2fbf97bc8b41d9c9c93c4ce8418);
        else if (i == 6) return bytes32(0x1d58d460adb56c8f6ad8fe91512b0f5f81d69b16a1f828e5e25b3cfacddf812f);
        else if (i == 7) return bytes32(0x2ea62368d4712d562f3f9484206878fd038cbfeacd755e5b86a3c9b56fc184ca);
        else if (i == 8) return bytes32(0x20a3823e80100830efa9ea08e6c847d90f111922329668f7240f57708c533f1c);
        else if (i == 9) return bytes32(0x08426508015c3ee6f74cf7f55389ca579f9cdd46494bb93953984428ece81b97);
        else if (i == 10) return bytes32(0x2fb1a3a3dca3309b8363385b0af21782520eaa874a3cc499175065a7e1a2d12d);
        else if (i == 11) return bytes32(0x2e802d629926b5246d1a13f8988d0b3a09eee69ae463fddd221666bc6f440616);
        else if (i == 12) return bytes32(0x0700feb0288941fd323de28a639af903642f8499f80d2a84c41938ba0457f9a6);
        else if (i == 13) return bytes32(0x0398181ebe313c0ed828f87cf4780a3183b1dd55af42fac81e8d6d410847b826);
        else if (i == 14) return bytes32(0x2d942af183a5c9c54c2df28d2091b0effd726d4d227a38b8261f632bbe4ee84c);
        else if (i == 15) return bytes32(0x1c06fdc8e9920dd297fa61108935e41a08082393892da82015fbe17dcb3a4819);
        else if (i == 16) return bytes32(0x125e586ffbf3b6e03fe28fe84b2527de217486f197762fa7a1a7da950eec0c4f);
        else if (i == 17) return bytes32(0x2487288d5ef0130a9daeb2562585af147460eda1b54bdcb10f4e066d065effc6);
        else if (i == 18) return bytes32(0x12e8e40c0a6d4c3c68d33221cbce4a48ab608acae7681b0ed489de1559da8dce);
        else if (i == 19) return bytes32(0x1833d80a4d72124231120403abf0efa9ede8bcf37322ff82fe09703a6f49793e);
        else if (i == 20) return bytes32(0x2cc3565c2891c2801315cdad225a2ba97028ade69f99c71549f6a89d63cce5f8);
        else if (i == 21) return bytes32(0x06ab15002081d0d4e16c00a95d6f69a79344a0c8d983f8d40ecd552871f8e291);
        else if (i == 22) return bytes32(0x2654bb4b0f08b8c9e1bd8ea8b7b6f78b9663427426bb909ddc2765b8dfe9acd4);
        else if (i == 23) return bytes32(0x08e3ae3a17598651ad3fd1c71ec9933e474610edf1471babb7dfe53752201d00);
        else if (i == 24) return bytes32(0x15420fa1c989ac2309b95db7670e34e9bef83b2bf176c3031e1b3b6bcddc9baa);
        else if (i == 25) return bytes32(0x24854e3aeb79a123e6ea62ad9e9a696b3f4ca8255ef50daa04c7cb966e7f895a);
        else if (i == 26) return bytes32(0x11dbb9718fe630b545d5576ec5ed212aabb8c08718e8bf98255cb8fd497cdc00);
        else if (i == 27) return bytes32(0x090329659a36040238f44130d4436293bf50e3e9924626ab34f04843876c2ded);
        else if (i == 28) return bytes32(0x0153f8800b68c632af702ab0a284b170a31d547940b6cfe8f80cd0ed574640c6);
        else if (i == 29) return bytes32(0x1fc372a1ce5a6db26f3eb01438d8979342add6972785602a19da563d276b0688);
        else if (i == 30) return bytes32(0x1a09ee6fe8581957e27414ec9e78c4641cd544e483b612db17285764f19b4b27);
        else if (i == 31) return bytes32(0x2736d6451be553b640627683a12a4e886f061a4666e91819f8d1bbc0293ecda5);
        else revert("Index out of bounds");
    }
}
