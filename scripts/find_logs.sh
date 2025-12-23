#!/bin/bash

set -xeuo pipefail

sudo find /var/folders/ 2>&1 | ag squirrel | ag INFO
