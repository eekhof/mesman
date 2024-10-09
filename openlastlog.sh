#!/bin/bash
vim "$(ls -v JOBLOGS/*.log | tail -n 1)"
