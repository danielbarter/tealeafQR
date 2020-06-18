#!/bin/bash

clang -g tealeafQR.c main.c -o runtealeaf.elf -lfftw3 -lm
