#!/bin/bash

echo `xkblayout-state print "%s" | sed -e "s/ru/π·πΊ/g" -e "s/us/πΊπΈ/g"`
