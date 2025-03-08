# snx-packaged

Check Point's SSL Network eXtender (SNX) packaged into deb/rpm/etc.

# Installation
## Debian / Ubuntu

1. Install latest `snx` packaged version (800008407):
```
wget https://github.com/sergey-belikov/snx-packaged/releases/download/800008409-1/snx-800008409_800008409-1_amd64.deb && \
sudo dpkg --add-architecture i386 && \
sudo apt-get update && \
sudo apt -y install ./snx-800008409_800008409-1_amd64.deb
```
2. Copy `snx` config from template, write actual values for `server` and `username`:
```
wget https://raw.githubusercontent.com/sergey-belikov/snx-packaged/master/.snxrc.example && \
cp -v .snxrc.example ~/.snxrc && \
chmod 0600 ~/.snxrc && \
vim ~/.snxrc
```

Or simply write your new config `~/.snxrc`:

```
cat << EOF > ~/.snxrc
server vpn.gate.domain.name
username your-vpn-username
reauth yes
EOF
chmod 0600 ~/.snxrc
```

3. Run `/usr/local/bin/snx`. For example:

`snx -h`
```
Check Point's Linux SNX
build 800008409
usage: snx -s <server> {-u <user>|-c <certfile>} [-l <ca dir>] [-p <port>] [-r] [-g]
                                run SNX using given arguments
       snx -f <cf>              run the snx using configuration file
       snx                      run the snx using the ~/.snxrc

       snx -d                   disconnect a running SNX daemon

        -s <server>           connect to server <server>
        -u <user>             use the username <user>
        -c <certfile>         use the certificate file <certfile>
        -l <ca dir>           get trusted ca's from <ca dir>
        -p <port>             connect using port <port>
        -g                    enable debugging
```
## Package details

"Install package" is equal to copy one `snx` version as binary file into `/usr/bin/snx.8000XXXXX`
 and make symbolic link `/usr/local/bin/snx` as auto-alternative for `snx`,
 with "all required dependencies" (i386 libs).

Package **doesn't touch** file `/usr/bin/snx` installed by original Check Points's script `snx_install.sh`.

You may install multiple packages simultaneously and pick required version via alternatives:
```
$ which snx
/usr/local/bin/snx

$ ls -la /usr/bin/snx* /usr/local/bin/snx* /etc/alternatives/snx
lrwxrwxrwx 1 root root      22 Mar  8 14:50 /etc/alternatives/snx -> /usr/bin/snx.800008409
-r-s--x--x 1 root root 4123948 Dec 11  2023 /usr/bin/snx.800008209
-r-s--x--x 1 root root 4124396 Dec 11  2023 /usr/bin/snx.800008304
-r-s--x--x 1 root root 9079808 May 31  2024 /usr/bin/snx.800008407
-r-s--x--x 1 root root 9088992 Mar  8 14:50 /usr/bin/snx.800008409
lrwxrwxrwx 1 root root      21 Dec 11  2023 /usr/local/bin/snx -> /etc/alternatives/snx

$ update-alternatives --display snx
snx - auto mode
  link best version is /usr/bin/snx.800008409
  link currently points to /usr/bin/snx.800008409
  link snx is /usr/local/bin/snx
/usr/bin/snx.800008209 - priority 8209
/usr/bin/snx.800008304 - priority 8304
/usr/bin/snx.800008407 - priority 8407
/usr/bin/snx.800008409 - priority 8409
```

All `snx` ("packaged" and "original") equal use directories `/etc/snx/` and `/etc/snx/tmp/`.

### **IMPORTANT!**

Removing a last package with `apt purge ...` removes all package configs!

You will lose all your stored VPN gates root CA fingerprints!

# Building

Run script `./_rebuild_all_pkgs.sh` to rebuild all packages.

All built packages in directory `./dist`.

# Testing

**! Only run these after building all packages !**

Run script `./_test.all.sh` to run `snx -h` on matrix 'OS' - 'Version' - 'snx'.

"Checked" = create Docker container and successfull run `snx -h`. Not more, not less.

"Checked" on next Docker base images:

| OS     | OS Version | Code name      | Docker base image | Comment |
| ------ | ---------- | -------------- | ----------------- | ------- |
| Debian | NA | sid | debian:sid-slim |  |
| Debian | NA | testing | debian:testing-slim |  |
| Debian | 13 | Trixie | debian:trixie-slim |  |
| Debian | 12 LTS | Bookworm | debian:bookworm-slim |  |
| Debian | 11 | Bullseye | debian:bullseye-slim |  |
| Debian | 10 | Buster | debian:buster-slim |  |
| Ubuntu | 24.04 LTS | Noble Numbat | ubuntu:noble |  |
| Ubuntu | 22.04 LTS | Jammy Jellyfish | ubuntu:jammy |  |
| Ubuntu | 20.04 LTS | Focal Fossa | ubuntu:focal |  |
| Ubuntu | 18.04 LTS | Bionic Beaver |  ubuntu:bionic |  |

2025.03.08: I use package (`snx` version **800008409**) on Debian 12.9 (bookworm).

# Useful links

1. "SSL Network Extender" https://support.checkpoint.com/results/sk/sk65210

This SK article was moved to "SSL Network Extender (SNX) Administration Guide" https://sc1.checkpoint.com/documents/SSL_Network_Extender_AdminGuide/Content/Topics-SNX-Admin-Guide/SNX-Versions-and-Requirements.htm

2024.12.25: "The latest version of SNX is **80008409**."

Supported Linux Operating Systems for **80008409** (80008407):
- Ubuntu 16.04 - 23.10
- CentOS 8 - 9
- RHEL 8 - 9.3
- Fedora 24 - 39
- openSUSE Leap 42.1, 42.2, 42.3, Leap 15 - 15.5

Supported Linux Operating Systems for **80008304**:
- Ubuntu 16.04 - 22.04
- CentOS 7.3 - 7.6
- RHEL 7.3 - 7.6
- Fedora 24 - 30
- openSUSE Leap 42.1, 42.2, 42.3, Leap 15, Leap 15.1

2. "Using SSL Network Extender on Linux / macOS Operating Systems" https://sc1.checkpoint.com/documents/SSL_Network_Extender_AdminGuide/Content/Topics-SNX-Admin-Guide/SNX-for-RA-Linux-and-macOS.htm?tocpath=SSL%20Network%20Extender%20(SNX)%20for%20Remote%20Access%20VPN

Note - You can configure proxy server only in the configuration file and not directly from the command line.

3. "Mobile Access Portal Agent Prerequisites for Linux" https://support.checkpoint.com/results/sk/sk119772

4. `snx_install_linux30.sh` **800010003** from Check Point site. 2025.03.03: **May not work with you VPN gate server!**

https://support.checkpoint.com/results/download/22824

Get file here:
```
wget "https://dl3.checkpoint.com/paid/72/72c2c91791690927da0586ec873430cf/snx_install_linux30.sh?HashKey=1608304171_7ce1e383ff77a4ae39ceeb937d9be102&xtn=.sh" -O snx_install_linux30.sh
```

5. `snx_install.sh` **800008409**, or "compatible version for your VPN Gateway server":
```
wget "https://your.vpn.server/SNX/INSTALL/snx_install.sh" -O snx_install.sh
```

**Have fun!**
