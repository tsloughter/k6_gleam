// Returns runner name including js and gleam file name.
pub fn build_runner_name(name: String) -> #(String, String, String) {
  let name = name <> "_runner"
  #(name, name <> ".js", name <> ".gleam")
}
