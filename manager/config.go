package manager

import (
	"log"
	"os"
	"strconv"
	"strings"
	"time"

	"gopkg.in/yaml.v2"
)

// Config - Configuration taken from the yaml file
type Config struct {
	Runtime struct {
		LogTracing bool          `yaml:"log-tracing"`
		MainSleep  time.Duration `yaml:"main-sleep"`
		CustomEnv  string        `yaml:"custom-env"`
	} `yaml:"runtime"`
}

// updateEnvConfig - check eventual config environment variables
func updateEnvConfig(config *Config) {
	for _, e := range os.Environ() {
		pair := strings.SplitN(e, "=", 2)
		key := pair[0]
		value := pair[1]

		switch key {

		case "APP_MAIN_SLEEP":
			mainSleepEnv, err := time.ParseDuration(value)
			if err == nil {
				config.Runtime.MainSleep = mainSleepEnv
			}

		case "APP_LOG_TRACING_ON":
			logTracing, err := strconv.ParseBool(value)
			if err == nil {
				config.Runtime.LogTracing = logTracing
			}
		}
	}
}

// getYmlConfig - retrieve config from yaml file
func (config *Config) getYmlConfig(filePath string) error {
	yamlFile, err := os.Open(filePath)

	if err != nil {
		return err
	}
	defer yamlFile.Close()

	// Decode YAML file to struct
	if yamlFile != nil {
		decoder := yaml.NewDecoder(yamlFile)
		if err := decoder.Decode(&config); err != nil {
			log.Println(err.Error())
			return err
		}
	}

	return nil
}

// GetConfig - returns the main configuration file
func GetConfig(filePath string) Config {

	var config Config

	// gets the yaml configuration
	err := config.getYmlConfig(filePath)
	if err != nil {
		log.Panicf("GetConfig - error[%v]", err)
	}

	// overwrites any yaml configuration with Env Variables if present
	updateEnvConfig(&config)

	return config
}
