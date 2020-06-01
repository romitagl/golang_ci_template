#!/bin/bash

# replaces enviroment variables in template and outputs a new config file
eval "echo \"$(sed 's/"/\\"/g' ./config-template.yaml)\"" > config.yaml