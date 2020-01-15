#!/bin/bash
#supervisor -w /node/ /node/server.js
/usr/bin/nohup supervisor -w /node/ /node/server.js > /node/node.out 2>&1 & bash