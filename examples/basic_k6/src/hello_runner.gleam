import k6/http

pub fn main() {
  http.get("https://test.k6.io")
}
