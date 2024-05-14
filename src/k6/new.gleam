import argv
import gleam/io
import gleam/string
import simplifile

fn runner_gleam() -> String {
  // TODO(wingyplus): modify this source to a working k6 example.
  "
import gleam/io
import k6/http

pub fn main() {
  io.println(\"Hello from k6!\")
}
"
}

// Generate necessary files and configure a project to make it work on k6.
pub fn main() {
  let assert [name] = argv.load().arguments
  let assert Ok(cwd) = simplifile.current_directory()
  let runner_name = name <> "_runner"

  io.println("-- Write " <> runner_name)

  let assert Ok(Nil) =
    string.join([cwd, "src", runner_name <> ".gleam"], with: "/")
    |> simplifile.write(runner_gleam())
}
