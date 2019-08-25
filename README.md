<b style="color: #1383de">docker</b>&nbsp;+&nbsp;<b style="color: #730c15">WireGuard</b>

This docker image is based on the official docker [alpine](https://hub.docker.com/_/alpine) image with added support for WireGuard VPN.

## Usage
**Network Admin Capabilities:** It might be required to run this container using `--cap-add NET_ADMIN` in order to configure the virtual VPN network interface inside the docker VM properly.

**/etc/wireguard/config:** At the start of the container WireGuard will launch the wg0 interface base on the wg0.conf file in this directory. If no file is present `wg-startup.sh` will generate an example file including a new set of private/public keys.

Example command:

    docker run -d -it --rm --cap-add NET_ADMIN -v ${PWD}/config:/etc/wireguard/config aphex3k/alpine-wireguard:latest
