use std::hash::poseidon::bn254::hash_1;
use std::hash::poseidon::bn254::hash_2;
use poseidon_tree::compute_merkle_root;

fn main(
    index: Field,
    proof: [Field; 20],
    secret: Field,
    nullifier: Field,
    nullifierHash: pub Field,
    root: pub Field,
) {
    assert(hash_1([nullifier]) == nullifierHash);
    let leaf = hash_2([nullifier, secret]);
    let merkleRoot = compute_merkle_root(leaf, index, proof);
    assert(merkleRoot == root);
}

#[test]
fn test_main() {
    println(hash_2([0x45566C43F35A32B2FA6F36F83F105A51A6AFEB25C20FE3B14D9427C9CA948E, 0x3510144B50AAA1B94F12B0139AA6E55E9B4CEF9AAF545038B96300381ABB5C]));
    main(
        0,
        [
            0x27f427ccbf58a44b1270abbe4eda6ba53bd6ac4d88cf1e00a13c4371ce71d366,
            0x13e37f2d6cb86c78ccc1788607c2b199788c6bb0a615a21f2e7a8e88384222f8,
            0x217126fa352c326896e8c2803eec8fd63ad50cf65edfef27a41a9e32dc622765,
            0x0e28a61a9b3e91007d5a9e3ada18e1b24d6d230c618388ee5df34cacd7397eee,
            0x27953447a6979839536badc5425ed15fadb0e292e9bc36f92f0aa5cfa5013587,
            0x194191edbfb91d10f6a7afd315f33095410c7801c47175c2df6dc2cce0e3affc,
            0x1733dece17d71190516dbaf1927936fa643dc7079fc0cc731de9d6845a47741f,
            0x267855a7dc75db39d81d17f95d0a7aa572bf5ae19f4db0e84221d2b2ef999219,
            0x1184e11836b4c36ad8238a340ecc0985eeba665327e33e9b0e3641027c27620d,
            0x0702ab83a135d7f55350ab1bfaa90babd8fc1d2b3e6a7215381a7b2213d6c5ce,
            0x2eecc0de814cfd8c57ce882babb2e30d1da56621aef7a47f3291cffeaec26ad7,
            0x280bc02145c155d5833585b6c7b08501055157dd30ce005319621dc462d33b47,
            0x045132221d1fa0a7f4aed8acd2cbec1e2189b7732ccb2ec272b9c60f0d5afc5b,
            0x27f427ccbf58a44b1270abbe4eda6ba53bd6ac4d88cf1e00a13c4371ce71d366,
            0x1617eaae5064f26e8f8a6493ae92bfded7fde71b65df1ca6d5dcec0df70b2cef,
            0x20c6b400d0ea1b15435703c31c31ee63ad7ba5c8da66cec2796feacea575abca,
            0x09589ddb438723f53a8e57bdada7c5f8ed67e8fece3889a73618732965645eec,
            0x0064b6a738a5ff537db7b220f3394f0ecbd35bfd355c5425dc1166bf3236079b,
            0x095de56281b1d5055e897c3574ff790d5ee81dbc5df784ad2d67795e557c9e9f,
            0x11cf2e2887aa21963a6ec14289183efe4d4c60f14ecd3d6fe0beebdf855a9b63,
        ],
        0x3510144B50AAA1B94F12B0139AA6E55E9B4CEF9AAF545038B96300381ABB5C,
        0x45566C43F35A32B2FA6F36F83F105A51A6AFEB25C20FE3B14D9427C9CA948E,
        0x1ceafbc0d28154c1e55a15cb58bf84dd6fc25c79fda9aa595aeef8e12ed78022,
        0x17c6922ac7e9459132e66a20637a50622924e6e6eb2d3bd9519a0d330418d8e1,
    );
}
