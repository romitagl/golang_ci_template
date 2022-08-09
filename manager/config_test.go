package manager

import (
	"os"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

const errMessage string = "wrong configuration value found"

// nominal case
func TestGetConfig(t *testing.T) {

	config := GetConfig("../config/config.yaml")

	if config.Runtime.LogTracing != true {
		t.Errorf("runtime:log-tracing - " + errMessage)
	}

	if config.Runtime.MainSleep != time.Hour*24 {
		t.Errorf("runtime:main-sleep -  " + errMessage)
	}

	if config.Runtime.CustomEnv != "" {
		t.Errorf("runtime:custom-env -  " + errMessage)
	}
}

// test overriding of configuration with environment variables
func TestGetConfig_Env(t *testing.T) {

	os.Setenv("APP_MAIN_SLEEP", "5m")
	os.Setenv("APP_LOG_TRACING_ON", "false")

	config := GetConfig("../config/config.yaml")

	if config.Runtime.LogTracing != false {
		t.Errorf("runtime:log-tracing -  " + errMessage)
	}

	if config.Runtime.MainSleep != time.Minute*5 {
		t.Errorf("runtime:main-sleep -  " + errMessage)
	}
}

// test wrong file path
func TestGetConfig_WrongPath(t *testing.T) {

	assert.Panics(t, func() { GetConfig("./config/wrong_config.yaml") })

}

// test wrong yaml configuration
func TestGetConfig_WrongConfig(t *testing.T) {

	// yaml configuration with wrong syntax
	yaml := `
	runtime:
	  log-tracing: true # enable log traces
	  maain-sleep: "24h" # duration main process will sleep for
	  cuustom-env: "" # e.g. test/staging/production endpoint
	`
	// create and open a temporary file
	f, err := os.CreateTemp("", "tmpfile-*.yaml")
	if err != nil {
		t.Errorf(err.Error())
	}

	// close and remove the temporary file at the end of the program
	defer f.Close()
	defer os.Remove(f.Name())

	// write data to the temporary file
	// data := []byte("abc abc abc")
	if _, err := f.Write([]byte(yaml)); err != nil {
		t.Errorf(err.Error())
	}

	assert.Panics(t, func() { GetConfig(f.Name()) })

}
