#!/bin/bash

while [ true ]
do
	curl -i -F to=kenneth@devbox -F message=message-`date +%Y%m%d%H%M%S` http://localhost:9292/message
	curl -i -F recipients[]=kenneth@devbox -F message=broadcast-`date +%Y%m%d%H%M%S` http://localhost:9292/broadcast
	curl -i -F pool=sample -F message=pool-`date +%Y%m%d%H%M%S` http://localhost:9292/pool
done
