# Dockerized TP-Link Easy Smart Configuration Utility

This docker image runs the TL-ESCU in a container, forwarding the GUI
to a web browser using Xpra.

## Background

I own a TP-Link TL-SG108E v1, this switch is known to have many security issues regarding
its management interface. One of the issues in question is mitigated by connecting to
the switch via a dedicated management VLAN and doing configuration from there. I'm lazy,
I know that, so it's a matter of time since I start just accesing the switch from whatever
interface I happen to be connected to it, with no regards to the security issues. Besides from
that, using a Windows only application every time I want to change a setting is not what a
lazy person wants to do.

I made this container to solve this issues, since my server and the switch share a private
VLAN, accesing the management ports trough there is not an issue, and the utility runs in
the container, no need to boot up Windows to mess with the configs.

## External files

`escu.jar` is the main `.exe` file of TL-ESCU, just rename it to "escu.jar" and drop it alongside
the dockerfile for the main container, it works just as well as a jar file.
So far I wasn't able to make the app work with OpenJDK or any other java implementation except for
one Oracle provides, as it seems support for JavaFX is flaky, this means you'll need to get the JRE
link from the Java download page. Being limited to the Oracle implementation of Java also means that
there's limited or no support for other architectures like aarch64 (I wasn't able to find
a JRE for aarch64 from Oracle that comes with JavaFX).

## Usage

Example using docker compose (more on the socat container below)

```yaml
# Not sure if this high of a version is necesary
version: '3.7'

services:
  tplink_escu:
    command:
    - "--bind-tcp=0.0.0.0:8080,auth=file:filename=password.txt"
    image: fakuivan/xpra-tplink-escu
    networks:
      tplink_escu_net:
        aliases:
        # This alias ensures that we're forwarding to the same interface where the switch is
        - tplink_escu_on_net
    ports:
      - "8080:80"
    volumes:
    # utility.data should have uid of 1000, so does password.txt
    - source: /raid5/opt/tplink-escu/utility.data
      target: "/home/xpra_user/C:\\Users\\Public\\Documents\\TP-LINK\\utility.data"
      type: bind
    # don't write the password in with vim or some text editor
    # use something like `cat > password.txt`
    - "$COMPOSE_APP_ESCU_DATA/password.txt:/home/xpra_user/password.txt:ro"
  # Forwards broadcast packets from the switch to the xpra container
  socat:
    command:
    - udp-recvfrom:29809,fork
    - udp:tplink_escu_on_net:29809
    image: alpine/socat
    networks:
      tplink_escu_net: null

networks:
  tplink_escu_net:
    external: true
    name: tplink-escu
```

## Notes

Because of some differences between how Linux and Windows listen for broadcast packets,
a compagnion container is needed to forward broadcast packets from the switch to the main
container. Other solutions that don't use docker suggest using iptables to forward the packets,
but this is a pain to setup from a docker container.

## Resources

* [YouTube: TP-Link TL-SG108E Management Software on Linux](https://www.youtube.com/watch?v=tAU-HeN5eNs)
* [Setting up TP-Link TL-SG108E with Linux](https://shred.zone/cilla/page/383/setting-up-tp-link-tl-sg108e-with-linux.html) (explains the iptables commands)
* [Running TP-Link Easy Smart Configuration Utility on linux](https://www.wizzycom.net/running-tp-link-easy-smart-configuration-utility-on-linux/) (gives a script to enable and disable the forward rules)
* [Managing TP-Link easy smart switches from Linux](https://kcore.org/2015/08/30/managing-tp-link-easy-smart-switches-from-linux/)
