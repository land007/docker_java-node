#!/bin/bash
#/usr/bin/nohup supervisor -w /node/ /node/server.js > /node/node.out 2>&1 & bash
supervisor -w /node/ -i node_modules /node/server.js
