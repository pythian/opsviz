# Install graphite on non standard port so we can nginx reverse proxy to it behind auth
normal[:graphite][:listen_port] = "8081"
