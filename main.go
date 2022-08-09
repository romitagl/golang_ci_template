package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"time"

	"your-go-app/manager"
)

var (
	configFile = flag.String("config", "./config/config.yaml", "custom path to the yaml config file")
	version    = flag.Bool("version", false, "print out the version number and build date of the program")
	versionNo  string // version number of program
	buildDate  string // when the executable was built
	gitCommit  string // git commit hash
	goos       string // operating system
	goarch     string // architecture
)

func init() {
	// initialize logging flags.
	log.SetFlags(log.Ldate | log.Ltime | log.Lmicroseconds | log.Lshortfile | log.LUTC)
}

func main() {

	// parse input flags
	flag.Parse()

	// print version number and exit
	if *version {
		fmt.Printf("version: %s\nbuildDate: %s\ngitCommit: %s\ngoos: %s\ngoarch: %s\n", versionNo, buildDate, gitCommit, goos, goarch)
		os.Exit(0)
	}

	log.Println("-- program started --")

	// parse configuration => panic on error
	appConfig := manager.GetConfig(*configFile)

	for {
		// main loop
		if appConfig.Runtime.LogTracing {
			log.Println("sleeping for: ", appConfig.Runtime.MainSleep)
		}
		time.Sleep(appConfig.Runtime.MainSleep)
	}
}
