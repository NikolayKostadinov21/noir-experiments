use dep::bignum::{BigNumTrait, U256};
use bignum::bignum::to_field;
mod utils;
use crate::utils::CSPRNG;
pub global TWO_POW_128_MIN_1: Field = 340282366920938463463374607431768211455; // 2^128 - 1
pub global TWO_POW_128: Field = 340282366920938463463374607431768211456; // 2^128
pub global TWO_POW_120: u128 = 0x1000000000000000000000000000000;
pub global TWO_POW_240_MIN_1: Field =
    1766847064778384329583297500742918515827483896875618958121606201292619775;

pub global TWO_POW_239_MIN_1: Field =
    883423532389192164791648750371459257913741948437809479060803100646309887;
fn main(x: Field, y: pub Field) {
    assert(x != y);
}

unconstrained fn x__() -> Field {
    1 as Field / 15 as Field
}

unconstrained fn split_120_bits(mut x: Field) -> (u128, u128) {
    print(x);
    let low = (x as u128) % TWO_POW_120;
    let high = ((x - low as Field) / TWO_POW_120 as Field) as u128;
    (low, high)
}

pub fn field_from_bytes<let N: u32>(bytes: [u8; N], big_endian: bool) -> Field {
    assert(bytes.len() < 32, "field_from_bytes: N must be less than 32");
    let mut as_field = 0;
    let mut offset = 1;
    for i in 0..N {
        let mut index = i;
        if big_endian {
            index = N - i - 1;
        }
        as_field += (bytes[index] as Field) * offset;
        offset *= 256;
    }

    as_field
}

unconstrained fn padding_hex(round: u16) {
    let mut round = round;
    let mut result: [u8; 6] = (round as Field).to_le_bytes();
    let mut vec_res: Vec<u8> = Vec::new();
    let hex_chars = "0123456789ABCDEF".as_bytes();
    std::println(f"(round as Field).as_bytes(): {result}");
    std::println(f"hex_chars: {hex_chars}");
    let hex_chars = [30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 41, 42, 43, 44, 45, 46];
    let mut hex_chars_len = hex_chars.len();
    std::println(f"hex_chars_len: {hex_chars_len}");
    let mut new_index = 0;
    loop {
        if round > 0 {
            std::println(f"round: {round}");
            let remainder = (round as u8) % (16 as u8);
            std::println(f"remainder: {remainder}");
            vec_res.push(hex_chars[remainder]);
            result[new_index] = hex_chars[remainder];
            round = round / 16;
            new_index = new_index + 1;
        } else {
            break;
        }
    }

    let result = field_from_bytes(result, false);
    std::println(f"vec_res: {vec_res}");
    std::println(f"result: {result}");
}

#[test]
fn test_main() {
    // main(1, 2);
    // print("15 / 15: ");
    // println(15 as Field / 15 as Field);
    // print("16 / 15: ");
    // println(16 as Field / 15 as Field);
    // print("1 / 15: ");
    // println(1 as Field / 15 as Field);
    // print("1 / 15: ");
    // let x__ = unsafe { x__() };
    // println("x__: ");
    // println(x__);

    // let one = U256::from_slice([1, 0, 0]);
    // let two = U256::from_slice([2, 0, 0]);
    // let three = U256::from_slice([3, 0, 0]);
    // println("one: ");
    // println(one);
    // println("two: ");
    // println(two);
    // println("three: ");
    // println(three);
    // assert((one + two) == three);
    // println("four: ");

    // let TWO_POW_128_BIGNUM = U256::from_slice([340282366920938463463374607431768211455, 0, 0]);
    // let BIGNUM_15 = U256::from_slice([15, 0, 0]);
    // let BIGNUM_16 = U256::from_slice([16, 0, 0]);
    // println(TWO_POW_128_BIGNUM);
    // println(one.udiv(BIGNUM_15));
    // println(BIGNUM_16.udiv(BIGNUM_15));
    // let one = U256::from_slice([45, 0, 0]);
    // println(unsafe { one.__udiv_mod(BIGNUM_15) });
    // println(unsafe { BIGNUM_16.__udiv_mod(BIGNUM_15) });
    // let exp_bignum = U256::from_slice([1329227995784915872903807060280344575, 0, 0]);
    // print("one as bignum to one as field: ");
    // println(to_field(exp_bignum));
    // print("TWO_POW_239_MIN_1: ");
    // println(TWO_POW_239_MIN_1);
    // let (low, high) = unsafe { split_120_bits(TWO_POW_239_MIN_1) };
    // print("low: ");
    // println(low);
    // print("high: ");
    // println(high);
    // println("========================================");
    // println("========================================");
    //     let initial_seed = [
    //     0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF,
    //     0x42, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,
    //     0x88, 0x99, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF,
    //     0xFF, 0xEE, 0xDD, 0xCC, 0xBB, 0xAA, 0x99, 0x88
    // ];
    // let mut rng = CSPRNG::new(initial_seed);

    // let random_number_sha = rng.generate(0); // Using SHA-256
    // let random_number_blake = rng.generate(1); // Using Blake2s
    // let random_number_keccak = rng.generate(2); // Using Keccak256

    // std::println(f"Random number using SHA-256: {random_number_sha}");
    // std::println(f"Random number using Blake2s: {random_number_blake}");
    // std::println(f"Random number using Keccak256: {random_number_keccak}");

    // // Reseed and generate another random number
    // let new_seed = [0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF,
    //                 0x10, 0x32, 0x54, 0x76, 0x98, 0xBA, 0xDC, 0xFE,
    //                 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,
    //                 0x88, 0x99, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF];
    // rng.reseed(new_seed);
    // let random_number_after_reseed = rng.generate(0); // Using SHA-256 after reseeding
    // std::println(f"Random number after reseeding: {random_number_after_reseed}");
    println("========================================");
    let mut num = 65535;
    let new_row = 0x0000000000000000000000000000000000000000000000000000000000000000;
    let hex_num = (6 as u16) as Field;
    let hex_num = hex_num;
    let result_of_hexes = new_row + hex_num;
    unsafe {padding_hex(255)};
    // std::println(f"result_of_hexes: {result_of_hexes}");
    // std::println(f"num: {num}");
    // std::println(f"hex_num: {hex_num}");
    // Uncomment to make test fail
    // main(1, 1);
}
