import * as hello_runner from "./dist/static/hello_runner.js";

if (!hello_runner.main) {
  throw new Error("A main function is required");
}

let runner_options = hello_runner.options();
export const options = {
  duration: runner_options.duration[0],
  vus: runner_options.vus[0],
  vusMax: runner_options.vus_max[0],
};

export default hello_runner.main;
