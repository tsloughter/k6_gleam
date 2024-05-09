import gleam/dict
import gleam/string
import simplifile
import tom

type GleamToml =
  dict.Dict(String, tom.Toml)

pub fn read_gleam_toml(path: String) -> GleamToml {
  let gleam_toml_path = string.join([path, "gleam.toml"], with: "/")
  let assert Ok(gleam_toml_contents) = simplifile.read(gleam_toml_path)
  let assert Ok(gleam_toml) = tom.parse(gleam_toml_contents)
  gleam_toml
}

pub fn get_project_name(gleam_toml: GleamToml) -> String {
  let assert Ok(project_name) = tom.get_string(gleam_toml, ["name"])
  project_name
}
