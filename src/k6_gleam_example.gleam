// TODO: move it to k6/http.gleam.
@external(javascript, "./k6_wrapper.js", "get")
pub fn get(url: string) -> string
