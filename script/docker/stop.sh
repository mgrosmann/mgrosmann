#!/bin/bash
for file in *.yaml
do
  docker compose -f $file stop ;
done