#!/bin/bash
mkdir "$1"/metadata/
mv "$1"/*.xml "$1"/metadata/
mv "$1"/*.description "$1"/metadata/
mv "$1"/*.json "$1"/metadata/
mv "$1"/*.jpg "$1"/metadata/
