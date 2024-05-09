import esgleam
import gleam/string
import simplifile
import tom

pub fn main() {
  let assert Ok(cwd) = simplifile.current_directory()
  let gleam_toml_path = string.join([cwd, "gleam.toml"], with: "/")
  let assert Ok(gleam_toml_contents) = simplifile.read(gleam_toml_path)
  let assert Ok(gleam_toml) = tom.parse(gleam_toml_contents)
  let assert Ok(project_name) = tom.get_string(gleam_toml, ["name"])

  esgleam.new("./dist/static")
  |> esgleam.entry(project_name <> ".gleam")
  |> esgleam.target("es2020")
  |> esgleam.raw("--external:k6/http")
  |> esgleam.bundle()
}
