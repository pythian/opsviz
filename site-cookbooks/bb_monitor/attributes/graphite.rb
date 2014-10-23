# Install graphite web on non standard port so we can nginx reverse proxy to it behind auth
normal['graphite']['uwsgi']['listen_http'] = true
normal['graphite']['listen_port'] = "8081"
