import esgleam
import k6/internal
import simplifile

pub fn main() {
  let assert Ok(cwd) = simplifile.current_directory()
  let project_name =
    cwd
    |> internal.read_gleam_toml()
    |> internal.get_project_name()

  esgleam.new("./dist/static")
  |> esgleam.entry(project_name <> ".gleam")
  |> esgleam.target("es2020")
  |> esgleam.raw("--external:k6/http")
  |> esgleam.bundle()
}
