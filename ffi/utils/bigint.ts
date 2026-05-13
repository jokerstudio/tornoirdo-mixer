import { randomBytes } from "node:crypto";

// Generates a random BigInt of specified byte length
export const rbigint = (nbytes: number): bigint => {
  return leBufferToBigint(randomBytes(nbytes));
};

// Converts a hex string value to BigInt.
export function hexToBigint(value: string | number | bigint): bigint {
  if (typeof value === "string") {
    if (value.startsWith("0x")) {
      return BigInt(value);
    }
    return BigInt("0x" + value);
  }
  return BigInt(value);
}

// Converts a BigInt to hex string of specified length
export const bigintToHex = (number: bigint, length: number = 32): string =>
  "0x" + number.toString(16).padStart(length * 2, "0");

// Converts a buffer of bytes into a BigInt, assuming little-endian byte order.
export const leBufferToBigint = (buff: Uint8Array): bigint => {
  let res = 0n;
  for (let i = 0; i < buff.length; i++) {
    const n = BigInt(buff[i]);
    res = res + (n << BigInt(i * 8));
  }
  return res;
};

// Converts a BigInt to a little-endian Buffer of specified byte length.
export function leBigintToBuffer(num: bigint, byteLength: number): Uint8Array {
  if (num < 0n) throw new Error("BigInt must be non-negative");

  const requiredLength = Math.ceil(num.toString(2).length / 8);
  if (byteLength < requiredLength) {
    throw new Error(
      `The specified byteLength (${byteLength}) is too small to represent the number`
    );
  }

  const buffer = new Uint8Array(byteLength);

  for (let i = 0; i < byteLength; i++) {
    buffer[i] = Number(num & 0xffn);
    num >>= 8n;
  }

  return buffer;
}
