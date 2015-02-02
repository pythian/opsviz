# Install graphite web on non standard port so we can nginx reverse proxy to it behind auth
normal['graphite']['uwsgi']['listen_http'] = true
normal['graphite']['uwsgi']['port'] = "8081"
