package k6_gleam

import (
	"os"
	"path/filepath"
	"strings"

	"github.com/grafana/k6pack"
	"github.com/sirupsen/logrus"
	"github.com/tsloughter/k6_gleam/k6-gleam/internal/gleam"
)

func init() {
	redirectStdin()
}

// Copied from https://github.com/grafana/xk6-ts/blob/master/loader.go#L17
func isRunCommand(args []string) (bool, int) {
	argn := len(args)

	scriptIndex := argn - 1
	if scriptIndex < 0 {
		return false, scriptIndex
	}

	var runIndex int

	for idx := 0; idx < argn; idx++ {
		arg := args[idx]
		if arg == "run" && runIndex == 0 {
			runIndex = idx

			break
		}
	}

	if runIndex == 0 {
		return false, -1
	}

	return true, scriptIndex
}

// Uses script from `run` sub-command and transpile gleam into js and load it back
// to `k6` using stdin option.
func redirectStdin() {
	isRun, scriptIndex := isRunCommand(os.Args)
	if !isRun {
		return
	}

	// TODO: detect .gleam extension.
	filename := os.Args[scriptIndex]

	logrus.Infof("Get script named %s", filename)
	logrus.Info("Build a gleam project...")

	if err := gleam.Build(); err != nil {
		logrus.WithError(err).Fatal()
	}

	cwd, err := os.Getwd()
	if err != nil {
		logrus.WithError(err).Fatal()
	}

	logrus.Info("Bundling...")

	filename, contents, err := jsBuildFile(cwd, filename)
	if err != nil {
		logrus.WithError(err).Fatal()
	}

	opts := k6pack.Options{
		Filename:   filename,
		SourceRoot: cwd,
	}

	jsScript, err := k6pack.Pack(string(addRuntime(contents)), &opts)
	if err != nil {
		logrus.WithError(err).Fatal()
	}

	os.Args[scriptIndex] = "-"

	reader, writer, err := os.Pipe()
	if err != nil {
		logrus.WithError(err).Fatal()
	}

	os.Stdin = reader

	go func() {
		_, werr := writer.Write(jsScript)
		writer.Close()

		if err != nil {
			logrus.WithError(werr).Fatal("stdin redirect failed")
		}
	}()
}

func addRuntime(source []byte) []byte {
	runtime := "\nexport default main;\n"
	return append(source, []byte(runtime)...)
}

// Convert gleam input filename into javascript file path.
func jsBuildFile(cwd, gleamFilename string) (filename string, contents []byte, err error) {
	filename = filepath.Base(gleamFilename)
	projName, err := gleam.ProjectName(cwd)
	if err != nil {
		return "", nil, err
	}
	// TODO: support more than dev?
	filename = filepath.Join(cwd, "build", "dev", "javascript", projName, strings.TrimRight(filename, ".gleam")+".mjs")
	contents, err = os.ReadFile(filename)
	return
}
