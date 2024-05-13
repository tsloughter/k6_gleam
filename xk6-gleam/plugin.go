package k6_gleam

import "go.k6.io/k6/js/modules"

type extension struct{}

func init() {
	modules.Register("k6/x/gleam", extension{})
}
