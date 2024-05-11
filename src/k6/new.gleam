import argv
import gleam/io
import gleam/string
import k6/internal
import simplifile

fn runner_js(name: String) -> String {
  "import { main } from './dist/static/{{ name }}.js'

export default main
  "
  |> string.replace(each: "{{ name }}", with: name)
}

fn runner_gleam() -> String {
  // TODO(wingyplus): modify this source to a working k6 example.
  "
import gleam/io

pub fn main() {
  io.println(\"Hello from k6!\")
}
"
}

// Generate necessary files and configure a project to make it work on k6.
pub fn main() {
  let assert [name] = argv.load().arguments
  let assert Ok(cwd) = simplifile.current_directory()
  let #(name, js_name, gleam_name) = internal.build_runner_name(name)

  io.println("-- Write " <> js_name)

  let assert Ok(Nil) =
    string.join([cwd, js_name], with: "/")
    |> simplifile.write(runner_js(name))

  io.println("-- Write " <> gleam_name)

  let assert Ok(Nil) =
    string.join([cwd, "src", gleam_name], with: "/")
    |> simplifile.write(runner_gleam())
}
