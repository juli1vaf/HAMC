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
        playit_cmd=(/usr/local/bin/playit agent)

        if [ -f "${playit_config}" ]; then
            if grep -q -- "--config" "${playit_config}"; then
                bashio::log.notice "Legacy Playit config containing deprecated --config flag detected; renaming ${playit_config}"
                mv "${playit_config}" "${playit_config}.legacy"
            else
                playit_cmd+=(--config-path "${playit_config}")
            fi
        fi

        SECRET_KEY="$(bashio::config 'PLAYIT_SECRET')" "${playit_cmd[@]}" >> "${playit_log}" 2>&1 &
        echo $! > /var/run/playit.pid
        bashio::log.info "Playit.gg agent started with PID $(cat /var/run/playit.pid)"
    fi
fi

/start
