import gleam/io
import gleam/string
import k6/internal
import simplifile

fn runner_mjs(project_name: String) -> String {
  "import { main } from './dist/static/{{ project_name }}.js'

export default main
  "
  |> string.replace(each: "{{ project_name }}", with: project_name)
}

// Generate necessary files and configure a project to make it work on k6.
pub fn main() {
  let assert Ok(cwd) = simplifile.current_directory()
  let project_name =
    cwd
    |> internal.read_gleam_toml()
    |> internal.get_project_name()

  io.println("-- Write runner.mjs")

  let assert Ok(Nil) =
    string.join([cwd, "runner.mjs"], with: "/")
    |> simplifile.write(runner_mjs(project_name))
}
