import http from "k6/http";

export function get(url) {
  const res = http.get(url);
  return res.body;
}
