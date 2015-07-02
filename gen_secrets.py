#!/usr/bin/env python
"""
Create secure passwords for use in this stack.
"""

from __future__ import print_function
import random
import string

def gen_password(length=10):
    return u''.join([random.SystemRandom().choice("{}{}{}".format(string.ascii_letters, string.digits, u"!@#$%^&*(-_=+)")) for i in xrange(length)])


if __name__ == "__main__":
    print("rabbitmq password for logger: {}".format(gen_password()))
    print("rabbitmq password for logstash_internal: {}".format(gen_password()))
    print("rabbitmq password for logstash_external: {}".format(gen_password()))
    print("rabbitmq password for sensu : {}".format(gen_password()))
    print("rabbitmq password for statsd: {}".format(gen_password()))
    print("database password for grafana: {}".format(gen_password()))
    print("")
    print("rabbitmq erlang cookie: {}".format(gen_password(50)))
    print("rabbitmq doorman session_secret: {}".format(gen_password(50)))
