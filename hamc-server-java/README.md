# HAMC Server (Java) - JULIEN

This add-on allows for hosting a Minecraft Java server using Home Assistant. Based on the Minecraft server docker by [itzg](https://github.com/itzg/docker-minecraft-server).

## Configuration

All configuration is done using the add-on options. It allows for setting the environment variables found [here](https://github.com/itzg/docker-minecraft-server).

### Playit.gg tunnel

The add-on bundles the [Playit.gg](https://playit.gg/) agent so the public tunnel can run inside the same container as the Minecraft server. To enable it:

1. Set **PLAYIT_ENABLE** to `true` in the add-on options.
2. Provide your **PLAYIT_SECRET** (the secret key from your Playit.gg account) so the agent can authenticate.

When enabled, the Playit agent starts automatically alongside the Minecraft server and keeps running for as long as the add-on is active.

To access the Minecraft server from outside your network, forward port 25565 (TCP) on your router. Then connect using:

```
<your_ip>:25565
```

## References

* Thanks to [alexbelgium](https://github.com/alexbelgium/hassio-addons) for the add-on template.

* Thanks to [itzg](https://github.com/itzg/docker-minecraft-server) for the docker image.
