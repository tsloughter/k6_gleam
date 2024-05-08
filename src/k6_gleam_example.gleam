@external(javascript, "./k6_wrapper.js", "get")
pub fn get(url: string) -> string

pub fn main() {
  get("http://test.k6.io")
}
