import http from 'k6/http';

function get(url) {
  const res = http.get(url);

  return res.body;
}

export { get };
