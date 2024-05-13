import gleam/option.{Some}
import k6/http
import k6/options.{type Options, Options}

pub fn options() -> Options {
  Options(duration: Some("10s"), vus: Some(10))
}

pub fn main() {
  http.get("https://test.k6.io")
}
