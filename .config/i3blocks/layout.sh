#!/bin/bash

echo `xkblayout-state print "%s" | sed -e "s/ru/🇷🇺/g" -e "s/us/🇺🇸/g"`
