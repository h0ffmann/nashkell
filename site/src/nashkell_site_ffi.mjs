// The three functions of JavaScript's Math that Gleam's standard library does not have.
export const sin = Math.sin;
export const cos = Math.cos;
export const pi = () => Math.PI;

// Writes a file at build time, for `just plots` (node only; the page itself never calls it).
import { writeFileSync, mkdirSync } from "node:fs";
export function write_file(path, text) {
  mkdirSync(path.substring(0, path.lastIndexOf("/")) || ".", { recursive: true });
  writeFileSync(path, text);
  return undefined;
}
