# snx-packaged

Check Point's SSL Network eXtender (SNX) packaged into deb/rpm/etc.

# Installation
## Debian / Ubuntu

1. Install latest `snx` packaged version (800010003):
```
wget https://github.com/sergey-belikov/snx-packaged/releases/download/800010003.2/snx-800010003_800010003-2_amd64.deb && \
sudo dpkg --add-architecture i386 && \
sudo apt-get update && \
sudo apt -y install ./snx-800010003_800010003-2_amd64.deb
```
2. Copy `snx` config from template, write actual values for `server` and `username`:
```
wget https://raw.githubusercontent.com/sergey-belikov/snx-packaged/master/.snxrc.example && \
cp -v .snxrc.example ~/.snxrc && \
chmod -m 0600 ~/.snxrc && \
vim ~/.snxrc
```

Or simply write your new config `~/.snxrc`:

```
cat << EOF > ~/.snxrc
server vpn.gate.domain.name
username your-vpn-username
reauth yes
EOF
chmod -m 0600 ~/.snxrc
```

3. Run `/usr/local/bin/snx`. For example:

`snx usage`
```
a username or a certificate were not supplied
Check Point's Linux SNX
build 800010003
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
        -b                    run in backward compatability mode
```
## Package details

'Install package' is equal to copy one `snx` version as binary file into `/usr/bin/snx.8000XXXXX`
 and make symbolic link '/usr/local/bin/snx' as auto-alternative for `snx`,
 with "all required dependencies" (i386 libs).

Package **doesn't touch** file `/usr/bin/snx` installed by original Check Points's script `snx_install.sh`.

You may install multiple packages simultaneously and pick required version via alternatives:
```
$ which snx
/usr/local/bin/snx

$ ls -la /usr/bin/snx* /usr/local/bin/snx* /etc/alternatives/snx
lrwxrwxrwx 1 root root      22 Dec 11 07:31 /etc/alternatives/snx -> /usr/bin/snx.800010003
-r-s--x--x 1 root root 4123948 Dec 10 08:00 /usr/bin/snx.800008209
-r-s--x--x 1 root root 4124396 Dec 10 08:00 /usr/bin/snx.800008304
-r-s--x--x 1 root root 4143464 Dec 10 08:00 /usr/bin/snx.800010003
lrwxrwxrwx 1 root root      21 Dec 11 07:31 /usr/local/bin/snx -> /etc/alternatives/snx

$ update-alternatives --display snx
Alternatives:
snx - auto mode
  link best version is /usr/bin/snx.800010003
  link currently points to /usr/bin/snx.800010003
  link snx is /usr/local/bin/snx
/usr/bin/snx.800008209 - priority 8209
/usr/bin/snx.800008304 - priority 8304
/usr/bin/snx.800010003 - priority 10003
```

All `snx` ("packaged" and "original") equal use directories `/etc/snx/` and `/etc/snx/tmp/`.

### **IMPORTANT!**

Removing package with `apt purge ...` removes all package configs!

You will lose all your stored VPN gates root CA fingerprints!

# Building

Run script `./_rebuild_all_pkgs.sh` to rebuild all packages.

All built packages in directory `./dist`.

# Testing

**! Only run these after building all packages !**

Run script `./_test.all.sh` to run `snx usage` on matrix 'OS' - 'Version' - 'snx'.

"Checked" = create Docker container and successfull run `snx usage`. Not more, not less.

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
| Ubuntu | 23.10 | Mantic Minotaur | ubuntu:mantic |  |
| Ubuntu | 23.04 | Lunar Lobster | ubuntu:lunar |  |
| Ubuntu | 22.04 LTS | Jammy Jellyfish | ubuntu:jammy |  |
| Ubuntu | 20.04 LTS | Focal Fossa | ubuntu:focal |  |
| Ubuntu | 18.04 LTS | Bionic Beaver |  ubuntu:bionic |  |

I use latest package (`snx` version 800010003) on Debian 12.4 (bookworm).

# Useful links

1. "SSL Network Extender" https://support.checkpoint.com/results/sk/sk65210

2023.12.11: "The current version of SSL Network Extender is **80008304**."

Supported Operating Systems:
- Ubuntu 16.04 - 22.04
- CentOS 7.3 - 7.6
- RHEL 7.3 - 7.6
- Fedora 24 - 30
- openSUSE Leap 42.1, 42.2, 42.3, Leap 15, Leap 15.1

2. "Mobile Access Portal Agent Prerequisites for Linux" https://support.checkpoint.com/results/sk/sk119772

4. `snx_install_linux30.sh` **800010003** from Check Point site

https://support.checkpoint.com/results/download/22824

Get file here:
```
wget "https://dl3.checkpoint.com/paid/72/72c2c91791690927da0586ec873430cf/snx_install_linux30.sh?HashKey=1608304171_7ce1e383ff77a4ae39ceeb937d9be102&xtn=.sh" -O snx_install_linux30.sh
```

4. `snx_install.sh` **800008304**, or "compatible version for your VPN Gateway server":
```
wget "https://your.vpn.server/SNX/INSTALL/snx_install.sh" -O snx_install.sh
```

**Have fun!**
