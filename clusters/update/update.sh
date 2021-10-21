#!/bin/bash

tmc cluster get cluster-cli -p lab -m seti-labs | ytt -f rebase.yml -f - -f cluster.yml  > cluster-update.yaml

tmc cluster update -f cluster-update.yaml

rm cluster-update.yaml