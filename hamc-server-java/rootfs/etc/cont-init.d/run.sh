#!/usr/bin/env bashio

bashio::log.info "Starting..."

if bashio::config.true 'PLAYIT_ENABLE'; then
    if ! bashio::config.has_value 'PLAYIT_SECRET'; then
        bashio::log.error "Playit.gg tunneling is enabled but no PLAYIT_SECRET was provided. The tunnel will not be started."
    else
        bashio::log.info "Starting Playit.gg tunnel agent"
        mkdir -p /var/log /var/run
        playit_log="/var/log/playit.log"
        playit_config="/data/playit.toml"

        /usr/local/bin/playit --config "${playit_config}" --secret "$(bashio::config 'PLAYIT_SECRET')" >> "${playit_log}" 2>&1 &
        echo $! > /var/run/playit.pid
        bashio::log.info "Playit.gg agent started with PID $(cat /var/run/playit.pid)"
    fi
fi

/start
