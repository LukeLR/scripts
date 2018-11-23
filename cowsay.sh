#!/bin/bash
fortune | $(shuf -n 1 -e cowsay cowthink) -n | lolcat
