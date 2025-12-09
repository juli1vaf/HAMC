## next

## 1.3.3

- Prevent build failures when `BUILD_ARCH` is unset by explicitly defaulting to the Docker target architecture or host machine
  name before Playit is downloaded.

## 1.3.2

- Fix Playit agent installation so builds succeed even when both `BUILD_ARCH` and `TARGETARCH` are not supplied by falling back
  to the host architecture.

## 1.3.1

- Allow Playit agent installation to fall back to the Docker build target architecture when `BUILD_ARCH` is not set by the builder.
- Provide a default base image value to avoid empty `BUILD_FROM` warnings during builds.

## 1.3.0

- Bundle the Playit.gg tunnel agent in the add-on image and allow starting it automatically alongside the Minecraft server.

## 1.2.0

- Exposed the RCON port (25575) for remote console access. Ensure to set a strong `RCON_PASSWORD` in the configuration to use this feature.
- Mount the data folder to `/addon_config` for easier access to configuration & world files by @meritw
- Fix the Gamemode option not working by renaming it to Mode

## 1.1.1

- Add ability to select server type by @joelhaasnoot

## 1.1.0

- Fixed HAOS option loading

## 1.0.0

- Initial release
