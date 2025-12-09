#!/usr/bin/env bashio

bashio::log.info "Starting..."

if bashio::config.true 'PLAYIT_ENABLE'; then
    if ! bashio::config.has_value 'PLAYIT_SECRET'; then
        bashio::log.error "Playit.gg tunneling is enabled but no PLAYIT_SECRET was provided."
        bashio::log.error "The tunnel will NOT be started."
    else
        bashio::log.info "Starting Playit.gg tunnel agent"

        mkdir -p /var/log /var/run
        playit_log="/var/log/playit.log"
        playit_config="/data/playit.toml"
        playit_cmd=(/usr/local/bin/playit agent)

        # Extract provided secret
        provided_secret="$(bashio::config 'PLAYIT_SECRET')"

        #
        # 1. If config file exists, check its compatibility
        #
        if [ -f "${playit_config}" ]; then

            # Detect deprecated configs containing "--config"
            if grep -q -- "--config" "${playit_config}"; then
                bashio::log.notice "Detected legacy playit.toml with deprecated --config flag."
                bashio::log.notice "Renaming ${playit_config} → ${playit_config}.legacy"
                mv "${playit_config}" "${playit_config}.legacy"

            else
                #
                # 2. Check if the stored secret matches the provided one
                #
                if grep -q "secret_key" "${playit_config}"; then
                    stored_secret="$(grep 'secret_key' "${playit_config}" \
                        | head -1 \
                        | sed 's/secret_key *= *"//' | sed 's/"//')"

                    if [ "${stored_secret}" != "${provided_secret}" ]; then
                        bashio::log.warning "playit.toml contains an outdated secret key."
                        bashio::log.warning "Replacing it so Playit can regenerate a correct config."

                        mv "${playit_config}" "${playit_config}.oldsecret"
                    else
                        # Same secret → safe to reuse config
                        bashio::log.info "playit.toml matches the provided secret — reusing existing configuration."
                        playit_cmd+=(--config-path "${playit_config}")
                    fi

                else
                    # No stored secret → reuse config anyway
                    bashio::log.info "playit.toml has no stored secret key — reusing configuration."
                    playit_cmd+=(--config-path "${playit_config}")
                fi
            fi
        fi

        #
        # 3. Start Playit agent with the secret key
        #
        SECRET_KEY="${provided_secret}" "${playit_cmd[@]}" >> "${playit_log}" 2>&1 &
        pid=$!
        echo "${pid}" > /var/run/playit.pid
        bashio::log.info "Playit.gg agent started with PID ${pid}"
    fi
fi

/start
