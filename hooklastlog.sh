#!/bin/bash
tail -f "$(ls -v JOBLOGS/*.log | tail -n 1)"
