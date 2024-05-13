import gleam/option.{type Option}

pub type Options {
  Options(duration: Option(String), vus: Option(Int))
}
