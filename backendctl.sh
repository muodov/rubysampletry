#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <start|stop|restart>"
    exit 1
fi
thin -R banners.ru -s3 -a 127.0.0.1 -e production $1

