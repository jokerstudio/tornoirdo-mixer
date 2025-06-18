// use std::hash::poseidon::bn254::hash_1;
// use std::hash::poseidon::bn254::hash_2;
use poseidon_tree::compute_merkle_root;
use poseidon::poseidon2::Poseidon2;

fn main(
    index: Field,
    proof: [Field; 20],
    secret: Field,
    nullifier: Field,
    nullifierHash: pub Field,
    root: pub Field,
) {
    assert(Poseidon2::hash([nullifier], 1) == nullifierHash);
    let leaf = Poseidon2::hash([nullifier, secret], 2);
    let merkleRoot = compute_merkle_root(leaf, index, proof);
    assert(merkleRoot == root);
}

#[test]
fn test_main() {
    main(
        0,
        [
            0x2fe54c60d3acabf3343a35b6eba15db4821b340f76e741e2249685ed4899af6c, 
            0x23a68130b6eaf098ac9787f6db712fedac1a6e61131b8f1910882fd97ac9640c,
            0x104e499fe6e3a6db4c5d162e5bbadafa710350a88e9597f2ef9c7676df71f105, 
            0x2f2b87271d226b4b46711b9678d3c7a6bb062e97c2f689132da519ca98dc8366,
            0x201d1cdf7deef2edc5c0a29ca0be2a090bd67ba8d9af89c3ab346a41c3695ae8, 
            0x1ada60ac49b96655764cd021f0841f0d44e6c2fbf97bc8b41d9c9c93c4ce8418,
            0x1d58d460adb56c8f6ad8fe91512b0f5f81d69b16a1f828e5e25b3cfacddf812f, 
            0x2ea62368d4712d562f3f9484206878fd038cbfeacd755e5b86a3c9b56fc184ca,
            0x20a3823e80100830efa9ea08e6c847d90f111922329668f7240f57708c533f1c, 
            0x08426508015c3ee6f74cf7f55389ca579f9cdd46494bb93953984428ece81b97,
            0x2fb1a3a3dca3309b8363385b0af21782520eaa874a3cc499175065a7e1a2d12d, 
            0x2e802d629926b5246d1a13f8988d0b3a09eee69ae463fddd221666bc6f440616,
            0x0700feb0288941fd323de28a639af903642f8499f80d2a84c41938ba0457f9a6, 
            0x0398181ebe313c0ed828f87cf4780a3183b1dd55af42fac81e8d6d410847b826,
            0x2d942af183a5c9c54c2df28d2091b0effd726d4d227a38b8261f632bbe4ee84c, 
            0x1c06fdc8e9920dd297fa61108935e41a08082393892da82015fbe17dcb3a4819,
            0x125e586ffbf3b6e03fe28fe84b2527de217486f197762fa7a1a7da950eec0c4f, 
            0x2487288d5ef0130a9daeb2562585af147460eda1b54bdcb10f4e066d065effc6,
            0x12e8e40c0a6d4c3c68d33221cbce4a48ab608acae7681b0ed489de1559da8dce, 
            0x1833d80a4d72124231120403abf0efa9ede8bcf37322ff82fe09703a6f49793e
        ],
        0x00afabf04f0d8ccec1661c4cc4d11a3960462804997554425d6c3890ce370b85,
        0x00d17166f15e39dda9f8e93c784d10abc8e4fbefc3d8ed753df24dca2513e446,
        0x2aee3bda1daeeb413b67a19fe3c60ace4b9787bec280171c48846a90c859e41a,
        0x058e025d63e7c203d1d6f1b3ab6e78d91371b99f984a096b28e8c2817915cb93,
    );
}
