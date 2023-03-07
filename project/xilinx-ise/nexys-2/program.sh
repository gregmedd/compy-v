#!/bin/bash

djtgcfg enum && djtgcfg init -d Nexys2 && djtgcfg prog -d Nexys2 -i 0 -f top.bit
