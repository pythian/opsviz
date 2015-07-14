#!/bin/bash
/confd -interval 1 -backend etcd -node ${ETCD_HOST}:${ETCD_PORT}
#/confd -interval 1 -backend etcd -node etcd:4001
