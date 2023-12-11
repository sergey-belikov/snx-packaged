# snx-packaged

Check Point's SSL Network eXtender (SNX) packaged into deb/rpm/etc.

# Install

Install package - copy one `snx` version as binary file into `/usr/bin/snx.8000XXXXX`
 and make symbolic link '/usr/local/bin/snx' as auto-alternative for `snx`,
 with "all required dependencies" (i386 libs).

Pakages **not crossed** with result from script `snx_install.sh` (`/usr/bin/snx`).

You may install many packages in one system. Example for all versions installed:
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

## Debian / Ubuntu

1. Install latest `snx` packaged version (800010003):
```
wget https://github.com/sergey-belikov/snx-packaged/releases/download/800010003/snx-800010003_800010003-2_amd64.deb && \
sudo dpkg --add-architecture i386 && apt-get update && apt -y install ./snx-800010003_800010003-2_amd64.deb
```
2. Copy `snx` config from template, write actual values for `server` and `username`:
```
wget https://raw.githubusercontent.com/sergey-belikov/snx-packaged/800010003/.snxrc.example
cp -v .snxrc.example ~/.snxrc
vim ~/.snxrc
```

3. Use `/usr/local/bin/snx` with:
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

# Rebuild

Run script `./_rebuild_all_pkgs.sh` for rebuild all packages.

All builded packages in directory `./dist`.

# Test

**! Only after local rebuild all packages !**

Run script `./_test.all.sh` for run `snx usage` on matrix 'OS' - 'Version' - 'snx'.

"Checked" = create Docker container and successfull run `snx usage`. Not more, not less.

"Checked" on next Docker base images:

| OS     | OS Version | Code name      | Docker base image | Comment |
| ------ | ---------- | -------------- | ----------------- | ------- |
| Debian | NA | sid | debian:sid-slim |  |
| Debian | NA | testing | debian:testing-slim |  |
| Debian | 13 | Trixie | debian:trixie-slim |  |
| Debian | 12 LTS | Bookworm | debian:bookworm-slim | Every day usage, "works for me" |
| Debian | 11 | Bullseye | debian:bullseye-slim |  |
| Debian | 10 | Buster | debian:buster-slim |  |
| ------ | ---------- | -------------- | ----------------- | ------- |
| Ubuntu | 24.04 LTS | Noble Numbat | ubuntu:noble |  |
| Ubuntu | 23.10 | Mantic Minotaur | ubuntu:mantic |  |
| Ubuntu | 23.04 | Lunar Lobster | ubuntu:lunar |  |
| Ubuntu | 22.04 LTS | Jammy Jellyfish | ubuntu:jammy |  |
| Ubuntu | 20.04 LTS | Focal Fossa | ubuntu:focal |  |
| Ubuntu | 18.04 LTS | Bionic Beaver |  ubuntu:bionic |  |
