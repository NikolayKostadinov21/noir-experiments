use dep::bignum::{BigNumTrait, U256};
use bignum::bignum::to_field;
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

#[test]
fn test_main() {
    main(1, 2);
    print("15 / 15: ");
    println(15 as Field / 15 as Field);
    print("16 / 15: ");
    println(16 as Field / 15 as Field);
    print("1 / 15: ");
    println(1 as Field / 15 as Field);
    print("1 / 15: ");
    let x__ = unsafe { x__() };
    println("x__: ");
    println(x__);

    let one = U256::from_slice([1, 0, 0]);
    let two = U256::from_slice([2, 0, 0]);
    let three = U256::from_slice([3, 0, 0]);
    println("one: ");
    println(one);
    println("two: ");
    println(two);
    println("three: ");
    println(three);
    assert((one + two) == three);
    println("four: ");

    let TWO_POW_128_BIGNUM = U256::from_slice([340282366920938463463374607431768211455, 0, 0]);
    let BIGNUM_15 = U256::from_slice([15, 0, 0]);
    let BIGNUM_16 = U256::from_slice([16, 0, 0]);
    println(TWO_POW_128_BIGNUM);
    println(one.udiv(BIGNUM_15));
    println(BIGNUM_16.udiv(BIGNUM_15));
    let one = U256::from_slice([45, 0, 0]);
    println(unsafe { one.__udiv_mod(BIGNUM_15) });
    println(unsafe { BIGNUM_16.__udiv_mod(BIGNUM_15) });
    let exp_bignum = U256::from_slice([1329227995784915872903807060280344575, 0, 0]);
    print("one as bignum to one as field: ");
    println(to_field(exp_bignum));
    print("TWO_POW_239_MIN_1: ");
    println(TWO_POW_239_MIN_1);
    let (low, high) = unsafe { split_120_bits(TWO_POW_239_MIN_1) };
    print("low: ");
    println(low);
    print("high: ");
    println(high);
    // Uncomment to make test fail
    // main(1, 1);
}
