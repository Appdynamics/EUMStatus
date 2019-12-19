#!/bin/bash 
# 
# Monitors Disks on Linux 
# 
# $Id: disk-stat.sh 3.20 2017-06-02 15:05:40 cmayer $
# 
# using only: iostat, awk
# 
# Copyright 2016 AppDynamics, Inc 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
# http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 
#
CURR_PATH=`pwd`
PATH=$PATH:/bin:/usr/sbin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$CURR_PATH

COUNTER=0
LOG_LINE=$(date +%F-%T)
LOG_LINE+="[INFO]: Starting monitoring extension...."

echo $LOG_LINE >> es_monitor.log

#SPACE SEPARATED LIST OF DISKS TO BE MONITORED THIS SHOULD MATHC THE DISKS ALREADY BEING MONITORED BY THE DiskMonitor extension
EUM_URL="eum-co.clarocloud.com.co"
EUM_PORT=7001

while [ $COUNTER -ge 0 ]; do
	#connecting to the cluster
	EUMAPI_HTTP_STATUS=$( curl http://$EUM_URL:$EUM_PORT/v2/current-time -s -o es_status.json -w "%{http_code}")
	EUMCOLLECTOR_HTTP_STATUS=$( curl http://$EUM_URL:$EUM_PORT/eumcollector/ping -s -o es_status.json -w "%{http_code}")
	EUMAGGREAGATOR_HTTP_STATUS=$( curl http://$EUM_URL:$EUM_PORT/eumaggregator/ping -s -o es_status.json -w "%{http_code}")
	EUMSCRSERVICE_HTTP_STATUS=$( curl http://$EUM_URL:$EUM_PORT/screenshots/v1/version -s -o es_status.json -w "%{http_code}")

	echo "name=Custom Metrics|EUM Server|EUM API http status,aggregator=AVERAGE,value=$EUMAPI_HTTP_STATUS"
	echo "name=Custom Metrics|EUM Server|EUM Collector http status,aggregator=AVERAGE,value=$EUMCOLLECTOR_HTTP_STATUS"
	echo "name=Custom Metrics|EUM Server|EUM Aggregator http status,aggregator=AVERAGE,value=$EUMAGGREAGATOR_HTTP_STATUS"
	echo "name=Custom Metrics|EUM Server|EUM Screenshot Service http status,aggregator=AVERAGE,value=$EUMSCRSERVICE_HTTP_STATUS"
	sleep 10
done

