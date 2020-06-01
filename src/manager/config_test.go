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

	config := GetConfig("../../config/config.yaml")

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

	config := GetConfig("../../config/config.yaml")

	if config.Runtime.LogTracing != false {
		t.Errorf("runtime:log-tracing -  " + errMessage)
	}

	if config.Runtime.MainSleep != time.Minute*5 {
		t.Errorf("runtime:main-sleep -  " + errMessage)
	}
}

// test wrong file path
func TestGetConfig_WrongPath(t *testing.T) {

	assert.Panics(t, func() { GetConfig("../../config/wrong_config.yaml") })

}
