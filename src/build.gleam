import esgleam

pub fn main() {
  esgleam.new("./dist/static")
  |> esgleam.entry("k6_gleam_example.gleam")
  |> esgleam.target("es2020")
  |> esgleam.raw("--external:k6/http")
  |> esgleam.bundle
}
