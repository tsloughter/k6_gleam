package gleam

import (
	"os"
	"os/exec"
	"path/filepath"

	"github.com/BurntSushi/toml"
)

// Build run build command.
func Build() error {
	// Ensure always build with js target.
	cmd := exec.Command("gleam", "build", "--target", "javascript")
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	return cmd.Run()
}

// ProjectName returns a project name defined in `gleam.toml`.
func ProjectName(cwd string) (string, error) {
	tm, err := os.ReadFile(filepath.Join(cwd, "gleam.toml"))
	if err != nil {
		return "", err
	}

	gleamToml := struct {
		Name string `toml:"name"`
	}{}
	if err := toml.Unmarshal(tm, &gleamToml); err != nil {
		return "", err
	}

	return gleamToml.Name, nil
}
