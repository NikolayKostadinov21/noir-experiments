use dep::std;
use dep::std::hash::{blake2s, pedersen_hash, pedersen_commitment};
use dep::std::hash::poseidon::bn254::{hash_1, hash_2};
use dep::std::hash::hash_to_field;

pub struct CSPRNG {
    seed: [u8; 32],
}

fn convert_from_field(field: Field) -> [u8; 32] {
    let mut bytes = [0 as u8; 32];
    let num = field as u64;
    for i in 0..32 {
        bytes[i] = ((num >> (8 * (31 - i))) & 0xff) as u8;
    }
    bytes
}
impl CSPRNG {
    fn new(seed: [u8; 32]) -> CSPRNG {
        CSPRNG { seed }
    }

    fn generate(&mut self, hash_method: u8) -> Field {
        if hash_method == 0 {
            // Using SHA-256
            self.seed = sha256::sha256_var(self.seed, self.seed.len() as u64);
        } else if hash_method == 1 {
            // Using Blake2s
            self.seed = std::hash::blake2s(self.seed);
        } else if hash_method == 2 {
            // Using Keccak256 (specify message_size as appropriate)
            let message_size = 32; // Example size
            self.seed = keccak256::keccak256(self.seed, message_size);
        }

        CSPRNG::convert_to_field(self.seed)
    }

    fn convert_to_field(hash_output: [u8; 32]) -> Field {
        let mut result: Field = 0;
        let mut v: Field = 1;

        for i in 0..32 {
            let index = 31 - i;  // Start from the end of the array
            result += hash_output[index] as Field * v;
            v *= 256;
        }

        result
    }
    fn reseed(&mut self, new_seed: [u8; 32]) {
        self.seed = new_seed;
    }
}

#[test]
fn test_csprng_initialization() {
    let seed = [0 as u8; 32];
    let rng = CSPRNG::new(seed);
    assert(rng.seed == seed);
}

#[test]
fn test_hash_method_sha256() {
    let mut rng = CSPRNG::new([0 as u8; 32]);
    let initial_seed = rng.seed;
    let _ = rng.generate(0); // SHA-256
    assert(rng.seed != initial_seed);
}

#[test]
fn test_hash_method_blake2s() {
    let mut rng = CSPRNG::new([0 as u8; 32]);
    let initial_seed = rng.seed;
    let _ = rng.generate(1); // Blake2s
    assert(rng.seed != initial_seed);
}

#[test]
fn test_hash_method_keccak256() {
    let mut rng = CSPRNG::new([0 as u8; 32]);
    let initial_seed = rng.seed;
    let _ = rng.generate(2); // Keccak256
    assert(rng.seed != initial_seed);
}

#[test]
fn test_csprng_different_seed_produces_different_output() {
    let mut rng1 = CSPRNG::new([1 as u8; 32]);
    let mut rng2 = CSPRNG::new([2 as u8; 32]);
    let output1 = rng1.generate(0); // SHA-256
    let output2 = rng2.generate(0); // SHA-256
    assert(output1 != output2);
}

#[test]
fn test_csprng_same_seed_produces_same_output() {
    let seed = [3 as u8; 32];
    let mut rng1 = CSPRNG::new(seed);
    let mut rng2 = CSPRNG::new(seed);
    let output1 = rng1.generate(0); // SHA-256
    let output2 = rng2.generate(0); // SHA-256
    assert(output1 == output2);
}

#[test]
fn test_csprng_generate_twice_changes_state_twice() {
    let mut rng = CSPRNG::new([4 as u8; 32]);
    let initial_seed = rng.seed;
    rng.generate(0); // SHA-256
    let post_first_generate = rng.seed;
    rng.generate(0); // SHA-256 again
    let post_second_generate = rng.seed;
    assert(initial_seed != post_first_generate);
    assert(post_first_generate != post_second_generate);
}

#[test]
fn test_csprng_reseed_changes_state() {
    let mut rng = CSPRNG::new([5 as u8; 32]);
    let initial_seed = rng.seed;
    rng.reseed([6 as u8; 32]);
    assert(rng.seed != initial_seed);
}

#[test]
fn test_csprng_reseed_different_seed_changes_output() {
    let mut rng = CSPRNG::new([8 as u8; 32]);
    let output_before_reseed = rng.generate(0); // SHA-256
    rng.reseed([9 as u8; 32]);
    let output_after_reseed = rng.generate(0); // SHA-256
    assert(output_before_reseed != output_after_reseed);
}

#[test]
fn test_csprng_generate_different_methods_produce_different_outputs() {
    let mut rng = CSPRNG::new([10 as u8; 32]);
    let output_sha256 = rng.generate(0); // SHA-256
    let output_blake2s = rng.generate(1); // Blake2s
    let output_keccak = rng.generate(2); // Keccak256
    assert(output_sha256 != output_blake2s);
    assert(output_sha256 != output_keccak);
    assert(output_blake2s != output_keccak);
}

#[test]
fn test_csprng_generate_same_method_consistent_output() {
    let mut rng1 = CSPRNG::new([11 as u8; 32]);
    let mut rng2 = CSPRNG::new([11 as u8; 32]);
    let output1_rng1 = rng1.generate(0); // SHA-256
    let output1_rng2 = rng2.generate(0); // SHA-256
    assert(output1_rng1 == output1_rng2);
}

#[test]
fn test_csprng_generate_multiple_methods_same_seed() {
    let seed = [12 as u8; 32];
    let mut rng1 = CSPRNG::new(seed);
    let mut rng2 = CSPRNG::new(seed);
    let output_sha256 = rng1.generate(0); // SHA-256
    let output_blake2s = rng2.generate(1); // Blake2s
    assert(output_sha256 != output_blake2s);
}

#[test]
fn test_csprng_generate_keccak256_with_different_message_sizes() {
    let mut rng = CSPRNG::new([13 as u8; 32]);
    rng.generate(2); // Keccak256 with default size
    let seed_after_default_size = rng.seed;
    rng.seed = [13 as u8; 32];
    keccak256::keccak256(rng.seed, 16); // Keccak256 with custom size
    let seed_after_custom_size = rng.seed;
    assert(seed_after_default_size != seed_after_custom_size);
}

#[test]
fn test_output_change() {
    let mut rng = CSPRNG::new([0 as u8; 32]);
    let output1 = rng.generate(0); // SHA-256
    let output2 = rng.generate(0); // SHA-256 again
    assert(output1 != output2);
}
#[test]
fn test_convert_to_field_all_zeros() {
    let bytes = [0 as u8; 32];
    let result = CSPRNG::convert_to_field(bytes);
    assert(result == 0);
}
