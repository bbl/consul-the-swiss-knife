#!/usr/bin/env bash

source '../consul_utils.sh'

consul_write 'kibana/config/elastic_host' 'http://elastic:9200'
consul_read 'kibana/config/elastic_host'

curl_consul_write 'rails/config/redis_host' 'http://redis:6379'
curl_consul_read 'rails/config/redis_host'