#!/usr/bin/env bash

cd ./page-generation
lake build
./.lake/build/bin/inset
