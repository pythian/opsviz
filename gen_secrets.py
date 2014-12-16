#!/usr/bin/env python
"""
Create secure passwords for use in this stack.
"""

import random
import string

def gen_password(length=10):
    return u''.join([random.SystemRandom().choice("{}{}{}".format(string.ascii_letters, string.digits, u"!@#$%^&*(-_=+)")) for i in range(length)])


if __name__ == "__main__":
    print("rabbitmq password for sensu : {}".format(gen_password()))
    print("rabbitmq password for statsd: {}".format(gen_password()))
    print("rabbitmq password for logger: {}".format(gen_password()))
    print("")
    print("rabbitmq password for logstash_external: {}".format(gen_password()))
    print("rabbitmq password for logstash_internal: {}".format(gen_password()))
    print("rabbitmq erlang cookie: {}".format(gen_password(50)))
