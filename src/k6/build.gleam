import argv
import esgleam
import k6/internal

pub fn main() {
  let assert [name] = argv.load().arguments

  let #(_, _, gleam_name) = internal.build_runner_name(name)

  esgleam.new("./dist/static")
  |> esgleam.entry(gleam_name)
  |> esgleam.target("es2020")
  |> esgleam.raw("--external:k6/http")
  |> esgleam.bundle()
}
