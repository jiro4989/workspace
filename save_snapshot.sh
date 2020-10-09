#!/bin/bash

set -eu

vagrant snapshot save `date +%Y-%m-%d`
vagrant snapshot list
